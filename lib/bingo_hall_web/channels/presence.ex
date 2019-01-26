defmodule BingoHallWeb.Presence do
  use Phoenix.Presence,
    otp_app: :bingo_hall,
    pubsub_server: BingoHall.PubSub
end
