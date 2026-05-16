import apps/auth/errors.{type AuthResult}
import dao/user as user_dao
import gleam/bit_array
import gleam/crypto
import gleam/option
import gleam/result
import midnight_domain/user.{type User}

fn hash_password(password: String) -> BitArray {
  crypto.hash(crypto.Sha256, bit_array.from_string(password))
}

/// Diz se um par usuário-senha está correto.
pub fn validate_user(username: String, password: String) -> AuthResult(Nil) {
  let hashed_password = hash_password(password)

  let user_from_db =
    user_dao.get_user_by_username(username)
    |> fn(x) {
      case x {
        Ok(option.Some(x)) -> Ok(x)
        Ok(option.None) -> Error(errors.WrongUser)
        Error(_) -> Error(errors.InternalError)
      }
    }

  use user <- result.try(user_from_db)

  case crypto.secure_compare(hashed_password, user.password) {
    True -> Ok(Nil)
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
