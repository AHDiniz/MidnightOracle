import midnight_domain.{type User, User}
import user_dao/sql
import utils

pub fn get_user_by_username(username: String) -> User {
  let assert Ok(rows) =
    utils.get_pog_connection()
    |> sql.get_user_by_username(username)

  let assert [row] = rows.rows

  User(username: row.username, email: row.email, password: row.password)
}
