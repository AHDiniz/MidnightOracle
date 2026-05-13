import dao/user as user_dao
import gleam/bit_array
import gleam/crypto
import gleam/option
import gleam/result
import midnight_domain/user.{type User}
import wisp

pub fn hash_password(password: String) -> BitArray {
  crypto.hash(crypto.Sha256, bit_array.from_string(password))
}

/// Diz se um par usuário-senha está correto.
/// Retorna `Error` caso haja um erro a nível de BD
pub fn validate_user(
  username: String,
  password: String,
) -> Result(Bool, String) {
  let hashed_password = hash_password(password)

  let user_from_db = user_dao.get_user_by_username(username)
  let user_from_db =
    result.map_error(user_from_db, fn(_) { "Erro ao conectar no BD" })

  use opt_user <- result.map(user_from_db)

  case opt_user {
    option.None -> False
    option.Some(user) -> {
      crypto.secure_compare(hashed_password, user.password)
    }
  }
}

pub fn persist_user(user: User) {
  let hashed_password = hash_password(user.password)
  let new_user =
    user_dao.EncryptedPasswordUser(user.username, user.email, hashed_password)
  user_dao.create_user(new_user)
}

pub fn error_json_response(msg: String, code: Int) {
  wisp.json_response("\"error\": \"" <> msg <> "\"", code)
}
