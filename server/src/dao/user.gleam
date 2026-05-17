import dao/base.{type DAOResult} as base_dao
import dao/user/sql
import gleam/option.{type Option}
import midnight_domain/user

pub type InternalUser {
  InternalUser(id: Int, username: String, email: String, password: BitArray)
}

pub fn get_user_by_id(id: Int) -> DAOResult(Option(user.User)) {
  base_dao.generic_get(fn(conn) { sql.get_user_by_id(conn, id) }, fn(row) {
    user.User(row.username, row.email, "")
  })
}

pub fn get_user_by_username(
  username: String,
) -> DAOResult(Option(InternalUser)) {
  base_dao.generic_get(
    fn(conn) { sql.get_user_by_username(conn, username) },
    fn(row) { InternalUser(row.id, row.username, row.email, row.password) },
  )
}

pub fn create_user(user: InternalUser) -> DAOResult(Nil) {
  base_dao.generic_create(fn(conn) {
    sql.create_user(conn, user.username, user.email, user.password)
  })
}
