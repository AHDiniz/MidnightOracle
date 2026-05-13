import dao/base as base_dao
import dao/user/sql
import gleam/option.{type Option}
import midnight_domain/user.{type User, User}

pub fn get_user_by_username(
  username: String,
) -> Result(Option(User), base_dao.DAOError) {
  base_dao.generic_get(
    fn(conn) { sql.get_user_by_username(conn, username) },
    fn(row) { User(row.username, row.email, "<REDACTED>") },
  )
}

/// `password` é passado por fora para que ele já venha encriptado
pub fn create_user(
  user: User,
  password: BitArray,
) -> Result(Nil, base_dao.DAOError) {
  base_dao.generic_create(fn(conn) {
    sql.create_user(conn, user.username, user.email, password)
  })
}
