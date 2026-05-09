import envoy
import gleam/erlang/process
import midnight_domain.{type User, User}
import pog
import user_dao/sql

pub fn get_user_by_username(username: String) -> User {
  let db_pool_name = process.new_name("db_pool")
  let assert Ok(database_url) = envoy.get("DATABASE_URL")
  let assert Ok(pog_config) = pog.url_config(db_pool_name, database_url)
  let assert Ok(_) =
    pog_config
    |> pog.pool_size(10)
    |> pog.start

  let conn = pog.named_connection(db_pool_name)

  let assert Ok(rows) = sql.get_user_by_username(conn, username)

  let assert [row] = rows.rows

  User(username: row.username, password: row.password, email: "")
}
