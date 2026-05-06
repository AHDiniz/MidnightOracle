//// This module contains the code to run the sql queries defined in
//// `./src/userDAO/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_user_by_username` query
/// defined in `./src/userDAO/sql/get_user_by_username.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetUserByUsernameRow {
  GetUserByUsernameRow(username: String, password: String)
}

/// Runs the `get_user_by_username` query
/// defined in `./src/userDAO/sql/get_user_by_username.sql`.
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
    use password <- decode.field(1, decode.string)
    decode.success(GetUserByUsernameRow(username:, password:))
  }

  "SELECT
  username, password
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
