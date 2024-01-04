defmodule DemooWeb.SessionController do
  use DemooWeb, :controller
  alias Demoo.Accounts
  alias Demoo.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => %{"username" => username, "password_digest" => password_digest}}) do
    changeset = User.login_changeset(%User{}, %{"username" => username, "password_digest" => password_digest})
    user = Accounts.get_user_by_username(username)
    IO.inspect(user, label: "User Map")
    IO.inspect(user.id, label: "User ID")

    cond do
      user && Bcrypt.verify_pass(password_digest, user.password_digest) ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Login successful.")
        |> redirect(to: "/movie")

      true ->
        conn
        |> put_flash(:error, "Invalid email or password.")
        |> render(:new, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "")
  end

end
