require IEx

defmodule BingoHallWeb.GameController do
  use BingoHallWeb, :controller

  alias Bingo.{GameServer, GameSupervisor}

  action_fallback GeneralFallbackController

  plug :require_player

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"game" => %{"size" => size}}) do
    game_name = BingoHall.HaikuName.generate()
    size = String.to_integer(size)

    case GameSupervisor.start_game(game_name, size) do
      {:ok, _pid} ->
        redirect(conn, to: Routes.game_path(conn, :show, game_name))

      {:error, error} ->
        conn
        |> put_flash(:error, "Unable start game, reason: #{error}")
        |> redirect(to: Routes.game_path(conn, :new))
    end
  end

  def show(conn, %{"id" => game_name}) do
    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
        conn
        |> assign(:game_name, game_name)
        |> assign(:auth_token, generate_auth_token(conn))
        |> render("show.html")

      nil ->
        conn
        |> put_flash(:error, "Game not found!")
        |> redirect(to: Routes.game_path(conn, :new))
    end
  end

  defp require_player(conn, _opts) do
    if get_session(conn, :current_player) do
      conn
    else
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  defp generate_auth_token(conn) do
    current_player = get_session(conn, :current_player)
    Phoenix.Token.sign(conn, "player auth", current_player)
  end
end
