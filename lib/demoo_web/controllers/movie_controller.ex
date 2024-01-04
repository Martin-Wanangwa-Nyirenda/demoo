defmodule DemooWeb.MovieController do
  use DemooWeb, :controller

  alias Demoo.Movies
  alias Demoo.Movies.Movie
  alias Demoo.Accounts

  plug :authenticate_user when action in [:index, :create, :new, :show, :edit, :delete]

  defp authenticate_user(conn, _) do

    if Plug.Conn.get_session(conn) == %{} do
      conn
        |> put_flash(:error, "You must be logged in to access this page.")
        |> redirect(to: "/session/new")
        |> halt()
    else
      conn
    end
  end

  def index(conn, _params) do
    current_user_id = Plug.Conn.get_session(conn)
    user = Accounts.get_user!(current_user_id["user_id"])
    movie = Movies.list_movie()
    render(conn, :index, movie_collection: movie, username: user.username)
  end

  def new(conn, _params) do
    changeset = Movies.change_movie(%Movie{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"movie" => movie_params}) do
    case Movies.create_movie(movie_params) do
      {:ok, movie} ->
        conn
        |> put_flash(:info, "Movie created successfully.")
        |> redirect(to: ~p"/movie/#{movie}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    render(conn, :show, movie: movie)
  end

  def edit(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    changeset = Movies.change_movie(movie)
    render(conn, :edit, movie: movie, changeset: changeset)
  end

  def update(conn, %{"id" => id, "movie" => movie_params}) do
    movie = Movies.get_movie!(id)

    case Movies.update_movie(movie, movie_params) do
      {:ok, movie} ->
        conn
        |> put_flash(:info, "Movie updated successfully.")
        |> redirect(to: ~p"/movie/#{movie}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, movie: movie, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    {:ok, _movie} = Movies.delete_movie(movie)

    conn
    |> put_flash(:info, "Movie deleted successfully.")
    |> redirect(to: ~p"/movie")
  end
end
