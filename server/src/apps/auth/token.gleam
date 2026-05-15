import dao/token/sql
import dao/user.{type InternalUser}
import gleam/crypto
import gleam/option.{type Option}

fn create_update_user_token(user: InternalUser) -> BitArray {
  let token = crypto.strong_random_bytes(64)

  // Update/create token na tabela, usando id do user, com calculo de timestamp em sql
  todo
}

pub fn get_token_for_user(user: InternalUser) -> BitArray {
  // get_valid_token_by_user_id

  // Se não existir token VÁLIDO para o usuario, criar com o create_update
  todo
}

pub fn get_user_by_token(token: BitArray) -> Option(Int) {
  // get_user_BY_token no banco

  // pode ou não existir
  todo
}
