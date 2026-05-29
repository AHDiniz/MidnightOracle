import apps/utils/errors.{type ServerResult}
import dao/token as token_dao
import dao/user.{type InternalUser}
import gleam/crypto

fn create_update_user_token(user: InternalUser) -> ServerResult(BitArray) {
  crypto.strong_random_bytes(64)
  |> token_dao.AuthToken(user.id, _)
  |> token_dao.create_update_user_token()
  |> errors.to_internal_error()
}

pub fn get_token_for_user(user: InternalUser) -> ServerResult(BitArray) {
  token_dao.get_token_by_user(user)
  |> errors.unwrap_result_option(fn() { create_update_user_token(user) })
}

pub fn get_user_by_token(token: BitArray) -> ServerResult(Int) {
  token_dao.get_user_id_by_token(token)
  |> errors.unwrap_result_option(fn() { Error(errors.Unauthorized) })
}
