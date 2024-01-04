defmodule Demoo.MoviesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Demoo.Movies` context.
  """

  @doc """
  Generate a movie.
  """
  def movie_fixture(attrs \\ %{}) do
    {:ok, movie} =
      attrs
      |> Enum.into(%{
        producer: "some producer",
        title: "some title"
      })
      |> Demoo.Movies.create_movie()

    movie
  end
end
