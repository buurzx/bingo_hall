require Protocol

defmodule BingoHallWeb.GameChannel do
  use BingoHallWeb, :channel

  alias BingoHallWeb.Presence
  alias Bingo.GameServer

  Protocol.derive(Jason.Encoder, Bingo.Square)
  Protocol.derive(Jason.Encoder, Bingo.Player)

  def join("games:" <> game_name, _params, socket) do
    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
        send(self(), {:after_join, game_name})
        {:ok, socket}

      nil ->
        {:error, %{reason: "Game does not exist"}}
    end
  end

  def handle_info({:after_join, game_name}, socket) do
    summary = GameServer.summary(game_name)

    push(socket, "game_summary", summary)

    push(socket, "presence_state", Presence.list(socket))

    {:ok, _} =
      Presence.track(socket, current_player(socket).name, %{
        online_at: inspect(System.system_time(:second)),
        color: current_player(socket).color
      })

    {:noreply, socket}
  end

  def handle_in("mark_square", %{"phrase" => phrase}, socket) do
    "games:" <> game_name = socket.topic

    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
        summary = GameServer.mark(game_name, phrase, current_player(socket))

        broadcast!(socket, "game_summary", summary)

        {:noreply, socket}

      nil ->
        {:reply, {:error, %{reason: "Game does not exist"}}, socket}
    end
  end

  def handle_in("new_chat_message", %{"body" => body}, socket) do
    broadcast!(socket, "new_chat_message", %{
      name: current_player(socket).name,
      body: body
    })

    {:noreply, socket}
  end

  defp current_player(socket) do
    socket.assigns.current_player
  end
end
