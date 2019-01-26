defmodule BingoHallWeb.SessionControllerTest do
  use BingoHallWeb.ConnCase

  alias BingoHall.Sessions

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:session) do
    {:ok, session} = Sessions.create_session(@create_attrs)
    session
  end

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "New Session"
    end
  end

  describe "create session" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.session_path(conn, :show, id)

      conn = get(conn, Routes.session_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Session"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.session_path(conn, :create), session: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Session"
    end
  end

  describe "delete session" do
    setup [:create_session]

    test "deletes chosen session", %{conn: conn, session: session} do
      conn = delete(conn, Routes.session_path(conn, :delete, session))
      assert redirected_to(conn) == Routes.session_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.session_path(conn, :show, session))
      end
    end
  end

  defp create_session(_) do
    session = fixture(:session)
    {:ok, session: session}
  end
end
