defmodule Demoo.Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movie" do
    field :producer, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :producer])
    |> validate_required([:title, :producer])
  end
end
