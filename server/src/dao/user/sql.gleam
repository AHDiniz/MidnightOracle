//// This module contains the code to run the sql queries defined in
//// `./src/dao/user/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// Runs the `create_user` query
/// defined in `./src/dao/user/sql/create_user.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn create_user(
  db: pog.Connection,
  arg_1: String,
  arg_2: String,
  arg_3: BitArray,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "INSERT INTO users (username, email, password)
VALUES ($1, $2, $3)
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.bytea(arg_3))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_user_by_username` query
/// defined in `./src/dao/user/sql/get_user_by_username.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetUserByUsernameRow {
  GetUserByUsernameRow(username: String, email: String, password: BitArray)
}

/// Runs the `get_user_by_username` query
/// defined in `./src/dao/user/sql/get_user_by_username.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_user_by_username(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(GetUserByUsernameRow), pog.QueryError) {
  let decoder = {
    use username <- decode.field(0, decode.string)
    use email <- decode.field(1, decode.string)
    use password <- decode.field(2, decode.bit_array)
    decode.success(GetUserByUsernameRow(username:, email:, password:))
  }

  "SELECT
  username, email, password
FROM
  users
where
  username=$1
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
