import dao/base as base_dao
import dao/user/sql
import gleam/option.{type Option}

pub type InternalUser {
  InternalUser(username: String, email: String, password: BitArray)
}

pub fn get_user_by_username(
  username: String,
) -> Result(Option(InternalUser), base_dao.DAOError) {
  base_dao.generic_get(
    fn(conn) { sql.get_user_by_username(conn, username) },
    fn(row) { InternalUser(row.username, row.email, row.password) },
  )
}

pub fn create_user(user: InternalUser) -> Result(Nil, base_dao.DAOError) {
  base_dao.generic_create(fn(conn) {
    sql.create_user(conn, user.username, user.email, user.password)
  })
}
