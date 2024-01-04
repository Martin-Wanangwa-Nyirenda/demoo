defmodule DemooWeb.UserControllerTest do
  use DemooWeb.ConnCase

  import Demoo.AccountsFixtures

  @create_attrs %{password_digest: "some password_digest", username: "some username"}
  @update_attrs %{password_digest: "some updated password_digest", username: "some updated username"}
  @invalid_attrs %{password_digest: nil, username: nil}

  describe "index" do
    test "lists all user", %{conn: conn} do
      conn = get(conn, ~p"/user")
      assert html_response(conn, 200) =~ "Listing User"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/user/new")
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/user", user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/user/#{id}"

      conn = get(conn, ~p"/user/#{id}")
      assert html_response(conn, 200) =~ "User #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/user", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, ~p"/user/#{user}/edit")
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/user/#{user}", user: @update_attrs)
      assert redirected_to(conn) == ~p"/user/#{user}"

      conn = get(conn, ~p"/user/#{user}")
      assert html_response(conn, 200) =~ "some updated password_digest"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/user/#{user}", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/user/#{user}")
      assert redirected_to(conn) == ~p"/user"

      assert_error_sent 404, fn ->
        get(conn, ~p"/user/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
