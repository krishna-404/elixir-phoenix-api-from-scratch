defmodule RealDealApiWeb.UserControllerTest do
  use RealDealApiWeb.ConnCase

  import RealDealApi.AccountsFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "update user" do
  #   setup [:create_account]

  #   test "renders user when data is valid", %{conn: conn, account: %Account{id: id} = account} do
  #     conn = put(conn, ~p"/api/users/#{account}", user: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, ~p"/api/users/#{id}")

  #     assert %{
  #              "id" => ^id,
  #              "biography" => "some updated biography",
  #              "full_name" => "some updated full_name",
  #              "gender" => "some updated gender"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, user: user} do
  #     conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  describe "delete user" do
    setup [:create_account]

    test "deletes chosen user", %{conn: conn, account_id: account_id} do
        conn = delete(conn, ~p"/api/users/#{account_id}")
        assert conn.status == 404
    end
  end

  defp create_account(_) do
    account = account_fixture()
    %{account_id: account.id}
  end
end
