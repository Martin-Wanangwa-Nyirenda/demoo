defmodule DemooWeb.Helpers.Auth do

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :user_id)
    if user_id, do: !!Demoo.Repo.get(Demoo.Accounts.User, user_id)
  end
end
