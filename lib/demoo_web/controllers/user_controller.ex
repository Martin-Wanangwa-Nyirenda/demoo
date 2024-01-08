defmodule DemooWeb.UserController do
  use DemooWeb, :controller

  alias Demoo.Accounts
  alias Demoo.Accounts.User
  alias DemooWeb.Helpers.Auth

  plug :authenticate_user when action in [:create, :new, :index]

  defp authenticate_user(conn, _) do
    if Auth.signed_in?(conn) do
      conn
    else
      conn |> redirect_to_signin()
    end
  end

  defp redirect_to_signin(conn) do
    conn
      |> put_flash(:error, "You must be logged in to access this page.")
      |> redirect(to: "/session/new")
      |> halt()
  end

  def index(conn, _params) do
    user = Accounts.list_user()
    render(conn, :index, user_collection: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/session/new")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, :edit, user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/user/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/user")
  end
end
