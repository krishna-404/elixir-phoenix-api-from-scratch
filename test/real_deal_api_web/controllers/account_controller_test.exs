defmodule RealDealApiWeb.AccountControllerTest do
  use RealDealApiWeb.ConnCase

  import RealDealApi.AccountsFixtures

  alias RealDealApi.Accounts.Account

  @create_attrs %{
    email: "some_email@example.com",
    hashed_password: "some_hashed_password",
    full_name: "some full_name",
    gender: "male",
    biography: "some biography"
  }
  @update_attrs %{
    email: "some_update_email@example.com",
    hashed_password: "some_update_hashed_password"
  }
  @invalid_attrs %{email: nil, hashed_password: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all accounts", %{conn: conn} do
      conn = get(conn, ~p"/api/accounts")
      assert json_response(conn, 200) == []
    end
  end

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some_email@example.com",
               "inserted_at" => _,
               "updated_at" => _
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts", account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update account" do
    setup [:create_account]

    test "renders account when data is valid", %{conn: conn, account: %Account{id: id} = account} do
      conn = put(conn, ~p"/api/accounts/#{account}", account: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, ~p"/api/accounts/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some_update_email@example.com",
               "inserted_at" => _,
               "updated_at" => _
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, account: account} do
      conn = put(conn, ~p"/api/accounts/#{account}", account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "sign in" do
    setup [:create_account]

    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts/sign_in", %{
        email: "some_email@example.com",
        password: "some_hashed_password"
      })


      assert %{
        "id" => _,
        "email" => "some_email@example.com",
        "token" => _
      } =json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts/sign_in", %{
        email: "some_email@example.com",
        password: "some_wrong_password"
      })
      IO.inspect(conn)

      assert %{"error" => "Invalid email or password"} = json_response(conn, 401)
    end
  end

  describe "delete account" do
    setup [:create_account]

    test "deletes chosen account", %{conn: conn, account: account} do
      conn = delete(conn, ~p"/api/accounts/#{account}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/accounts/#{account}")
      end
    end
  end

  defp create_account(_) do
    account = account_fixture()
    %{account: account}
  end
end
