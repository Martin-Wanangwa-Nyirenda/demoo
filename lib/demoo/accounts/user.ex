defmodule Demoo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :password_digest, :string
    field :username, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password_digest])
    |> validate_required([:username, :password_digest])
    |> unique_constraint(:username)
    |> update_change(:password_digest, &Bcrypt.hash_pwd_salt/1)
  end

  def login_changeset(session, attrs) do
    session
    |> cast(attrs, [:username, :password_digest], ~w())
    |> validate_required([:username, :password_digest])
  end
  # defp hash_password(changeset) do
  #   case get_change(changeset, :password) do
  #     nil -> changeset
  #     password ->
  #       put_change(changeset, :password_digest, Comeonin.Bcrypt.hashpwsalt(password))
  #   end
  # end
end
