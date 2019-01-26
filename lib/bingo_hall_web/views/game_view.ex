defmodule BingoHallWeb.GameView do
  use BingoHallWeb, :view

  def current_game_url(conn) do
    Routes.url(conn) <> conn.request_path
  end

  def grid_glyph(size) do
    content_tag :div, class: "grid-glyph" do
      for _row <- 1..size do
        content_tag :div, class: "row" do
          for _col <- 1..size do
            content_tag(:span, "", class: "box")
          end
        end
      end
    end
  end

  def ws_url do
    System.get_env("WS_URL") || BingoHallWeb.Endpoint.config(:ws_url)
  end
end
