import gleam/result
import midnight_domain.{type User, User}
import user_dao/sql
import utils

pub fn get_user_by_username(username: String) -> Result(User, String) {
  let res =
    utils.get_pog_connection()
    |> sql.get_user_by_username(username)
    |> result.map_error(fn(_) { "Erro de conexão" })
    |> result.map(fn(x) { x.rows })

  case res {
    Ok([row]) -> Ok(User(row.username, row.email, row.password))
    Ok([]) -> Error("Nenhum usuário encontrado")
    Ok([_, _, ..]) -> Error("Múltiplos usuários encontrados")
    Error(str) -> Error(str)
  }
}
