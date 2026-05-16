import apps/auth/errors.{type AuthResult}
import dao/token as token_dao
import dao/user.{type InternalUser}
import gleam/crypto
import gleam/option

fn create_update_user_token(user: InternalUser) -> AuthResult(BitArray) {
  crypto.strong_random_bytes(64)
  |> token_dao.AuthToken(user.id, _)
  |> token_dao.create_update_user_token()
  |> errors.to_internal_error()
}

pub fn get_token_for_user(user: InternalUser) -> AuthResult(BitArray) {
  case token_dao.get_token_by_user(user) {
    Ok(option.Some(t)) -> Ok(t)
    Ok(option.None) -> create_update_user_token(user)
    Error(_) -> Error(errors.InternalError)
  }
}

pub fn get_user_by_token(token: BitArray) -> AuthResult(Int) {
  case token_dao.get_user_id_by_token(token) {
    Ok(option.Some(id)) -> Ok(id)
    Ok(option.None) -> Error(errors.Unauthorized)
    Error(_) -> Error(errors.InternalError)
  }
}
