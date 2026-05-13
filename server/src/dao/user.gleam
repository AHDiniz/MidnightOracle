import dao/base as base_dao
import dao/user/sql
import gleam/option.{type Option}

pub type EncryptedPasswordUser {
  EncryptedPasswordUser(username: String, email: String, password: BitArray)
}

pub fn get_user_by_username(
  username: String,
) -> Result(Option(EncryptedPasswordUser), base_dao.DAOError) {
  base_dao.generic_get(
    fn(conn) { sql.get_user_by_username(conn, username) },
    fn(row) { EncryptedPasswordUser(row.username, row.email, row.password) },
  )
}

pub fn create_user(
  user: EncryptedPasswordUser,
) -> Result(Nil, base_dao.DAOError) {
  base_dao.generic_create(fn(conn) {
    sql.create_user(conn, user.username, user.email, user.password)
  })
}
