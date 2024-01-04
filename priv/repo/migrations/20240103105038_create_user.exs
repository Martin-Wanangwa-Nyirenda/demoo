defmodule Demoo.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :username, :string
      add :password_digest, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:user, [:username])
  end
end
