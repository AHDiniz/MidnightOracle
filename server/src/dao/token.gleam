import dao/base.{type DAOResult} as base_dao
import dao/token/sql
import dao/user.{type InternalUser}
import gleam/option.{type Option}
import gleam/result

pub type AuthToken {
  AuthToken(user_id: Int, token: BitArray)
}

pub fn create_update_user_token(token_info: AuthToken) -> DAOResult(BitArray) {
  base_dao.run_nil_query(fn(conn) {
    sql.create_or_update_token_by_user(
      conn,
      token_info.user_id,
      token_info.token,
    )
  })
  |> result.replace(token_info.token)
}

/// Só retorna um token se ele for válido
pub fn get_token_by_user(user: InternalUser) -> DAOResult(Option(BitArray)) {
  base_dao.run_get_query(
    fn(conn) { sql.get_valid_token_by_user_id(conn, user.id) },
    fn(row) { row.token },
  )
}

pub fn get_user_id_by_token(token: BitArray) -> DAOResult(Option(Int)) {
  base_dao.run_get_query(
    fn(conn) { sql.get_user_by_token(conn, token) },
    fn(row) { row.user_id },
  )
}
