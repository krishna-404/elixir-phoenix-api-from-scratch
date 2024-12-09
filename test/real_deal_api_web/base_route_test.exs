defmodule RealDealApiWeb.BaseRouteTest do
  use RealDealApiWeb.ConnCase, async: true

  test "GET /api", %{conn: conn} do
    conn = get(conn, "/api")
    assert text_response(conn, 200) =~ "The Real Deal API is running"
  end
end
