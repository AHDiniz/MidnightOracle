// import errors.{type DatabaseError, EmptyGetError, MultipleGetError, QueryError}
import dao/base as base_dao
import gleam/option.{type Option}
import midnight_domain.{type User, User}
import user_dao/sql
import utils

pub fn get_user_by_username(
  username: String,
) -> Result(Option(User), base_dao.DAOError) {
  utils.get_pog_connection()
  |> sql.get_user_by_username(username)
  |> base_dao.handle_get_result(fn(row) {
    User(row.username, row.email, row.password)
  })
}
