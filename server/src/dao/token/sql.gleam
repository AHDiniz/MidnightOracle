//// This module contains the code to run the sql queries defined in
//// `./src/dao/token/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// Runs the `create_or_update_token_by_user` query
/// defined in `./src/dao/token/sql/create_or_update_token_by_user.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_or_update_token_by_user(
  db: pog.Connection,
  arg_1: Int,
  arg_2: BitArray,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "INSERT INTO auth_token (user_id, token)
VALUES ($1, $2)
ON CONFLICT (user_id) DO UPDATE
  SET
    token = $2,
    expires_at = DEFAULT
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.bytea(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_user_by_token` query
/// defined in `./src/dao/token/sql/get_user_by_token.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetUserByTokenRow {
  GetUserByTokenRow(user_id: Int)
}

/// Runs the `get_user_by_token` query
/// defined in `./src/dao/token/sql/get_user_by_token.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_user_by_token(
  db: pog.Connection,
  arg_1: BitArray,
) -> Result(pog.Returned(GetUserByTokenRow), pog.QueryError) {
  let decoder = {
    use user_id <- decode.field(0, decode.int)
    decode.success(GetUserByTokenRow(user_id:))
  }

  "SELECT user_id
FROM auth_token
WHERE
  token = $1
  AND expires_at > NOW()
"
  |> pog.query
  |> pog.parameter(pog.bytea(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_valid_token_by_user_id` query
/// defined in `./src/dao/token/sql/get_valid_token_by_user_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetValidTokenByUserIdRow {
  GetValidTokenByUserIdRow(token: BitArray)
}

/// Runs the `get_valid_token_by_user_id` query
/// defined in `./src/dao/token/sql/get_valid_token_by_user_id.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_valid_token_by_user_id(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(GetValidTokenByUserIdRow), pog.QueryError) {
  let decoder = {
    use token <- decode.field(0, decode.bit_array)
    decode.success(GetValidTokenByUserIdRow(token:))
  }

  "SELECT token
FROM auth_token
WHERE
  user_id = $1
  AND expires_at > NOW()
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
