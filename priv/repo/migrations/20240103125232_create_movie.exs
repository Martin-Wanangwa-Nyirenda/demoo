defmodule Demoo.Repo.Migrations.CreateMovie do
  use Ecto.Migration

  def change do
    create table(:movie) do
      add :title, :string
      add :producer, :string

      timestamps(type: :utc_datetime)
    end
  end
end
