defmodule GeneralFallbackController do
  use BingoHallWeb, :controller

  def call(conn, {:error, msg}) do
    IO.puts(msg)

    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
  end

  def call(conn, msg) do
    IO.puts(msg)

    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render(:"404")
  end
end
