defmodule DemooWeb.MovieControllerTest do
  use DemooWeb.ConnCase

  import Demoo.MoviesFixtures

  @create_attrs %{producer: "some producer", title: "some title"}
  @update_attrs %{producer: "some updated producer", title: "some updated title"}
  @invalid_attrs %{producer: nil, title: nil}

  describe "index" do
    test "lists all movie", %{conn: conn} do
      conn = get(conn, ~p"/movie")
      assert html_response(conn, 200) =~ "Listing Movie"
    end
  end

  describe "new movie" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/movie/new")
      assert html_response(conn, 200) =~ "New Movie"
    end
  end

  describe "create movie" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/movie", movie: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/movie/#{id}"

      conn = get(conn, ~p"/movie/#{id}")
      assert html_response(conn, 200) =~ "Movie #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/movie", movie: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Movie"
    end
  end

  describe "edit movie" do
    setup [:create_movie]

    test "renders form for editing chosen movie", %{conn: conn, movie: movie} do
      conn = get(conn, ~p"/movie/#{movie}/edit")
      assert html_response(conn, 200) =~ "Edit Movie"
    end
  end

  describe "update movie" do
    setup [:create_movie]

    test "redirects when data is valid", %{conn: conn, movie: movie} do
      conn = put(conn, ~p"/movie/#{movie}", movie: @update_attrs)
      assert redirected_to(conn) == ~p"/movie/#{movie}"

      conn = get(conn, ~p"/movie/#{movie}")
      assert html_response(conn, 200) =~ "some updated producer"
    end

    test "renders errors when data is invalid", %{conn: conn, movie: movie} do
      conn = put(conn, ~p"/movie/#{movie}", movie: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Movie"
    end
  end

  describe "delete movie" do
    setup [:create_movie]

    test "deletes chosen movie", %{conn: conn, movie: movie} do
      conn = delete(conn, ~p"/movie/#{movie}")
      assert redirected_to(conn) == ~p"/movie"

      assert_error_sent 404, fn ->
        get(conn, ~p"/movie/#{movie}")
      end
    end
  end

  defp create_movie(_) do
    movie = movie_fixture()
    %{movie: movie}
  end
end
