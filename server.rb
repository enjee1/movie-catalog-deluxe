require "sinatra"
require "pg"
require "pry"

set :bind, '0.0.0.0'  # bind to all interfaces

configure :development do
  set :db_config, { dbname: "movies" }
end

configure :test do
  set :db_config, { dbname: "movies_test" }
end


def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

get "/actors" do
  @actors_array = []
  db_connection do |conn|
    sql = "SELECT name, id FROM actors ORDER BY name ASC"
    @actors_array = conn.exec(sql).to_a
  end

  erb :"actors/index"
end

get "/actors/:id" do
  actor_id = params["id"]
  @actor_profile = []
  db_connection do |conn|
    sql = "
    SELECT movies.title, cast_members.character, actors.name, actors.id
    FROM movies
    JOIN cast_members ON movies.id = cast_members.movie_id
    JOIN actors ON cast_members.actor_id = actors.id
    WHERE actors.id = ($1)
    ORDER BY movies.title"
    @actor_profile = conn.exec_params(sql, [actor_id]).to_a
  end
  erb :"actors/show"
end

get "/movies" do
  @movies = []
  db_connection do |conn|
    sql = "
    SELECT movies.title AS movie_title, movies.year AS release_year,
    movies.rating AS rating, movies.id AS movie_id, genres.name AS genre,
    studios.name AS studio_name
    FROM movies
    JOIN genres ON movies.genre_id = genres.id
    FULL JOIN studios on movies.studio_id = studios.id
    ORDER BY movies.title
    "
    @movies = conn.exec(sql).to_a
  end

  erb :"movies/index"
end

get "/movies/:id" do
  movie_id = params["id"]

  db_connection do |conn|
    sql = "
    SELECT
    "
  end
end
