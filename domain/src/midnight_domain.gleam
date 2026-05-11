import gleam/dynamic/decode

pub type User {
  User(username: String, email: String, password: String)
}

pub fn user_decoder() -> decode.Decoder(User) {
  use username <- decode.field("username", decode.string)
  use password <- decode.field("password", decode.string)
  use email <- decode.field("email", decode.string)
  decode.success(User(username:, password:, email:))
}
