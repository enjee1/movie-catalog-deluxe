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
    sql = "SELECT name, id FROM actors ORDER BY name ASC LIMIT 100"
    @actors_array = conn.exec(sql).to_a
  end

  erb :'actors/index'
end

get "/actors/:id" do
  actor_id = params["id"]
  
  db_connection do |conn|

  end
end
