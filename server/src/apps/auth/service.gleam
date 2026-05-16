import apps/auth/errors.{type AuthResult}
import apps/auth/token
import dao/user as user_dao
import gleam/bit_array
import gleam/crypto
import gleam/result
import midnight_domain/user.{type User}

fn hash_password(password: String) -> BitArray {
  crypto.hash(crypto.Sha256, bit_array.from_string(password))
}

/// Retorna o token de autenticação para um user-pass, se for válido
pub fn authenticate_user(
  username: String,
  password: String,
) -> AuthResult(String) {
  let hashed_password = hash_password(password)

  let user_from_db =
    user_dao.get_user_by_username(username)
    |> errors.unwrap_result_option(fn() { Error(errors.WrongUser) })

  use user <- result.try(user_from_db)

  case crypto.secure_compare(hashed_password, user.password) {
    True -> {
      token.get_token_for_user(user)
      |> result.map(fn(bit_arr) { bit_array.base64_encode(bit_arr, True) })
    }
    False -> Error(errors.WrongPass)
  }
}

/// Salva um User no banco de dados, com sua senha devidamente hasheada
pub fn persist_user(user: User) -> AuthResult(Nil) {
  hash_password(user.password)
  |> user_dao.InternalUser(-1, user.username, user.email, _)
  |> user_dao.create_user()
  |> errors.to_internal_error()
}
