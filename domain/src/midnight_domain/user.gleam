import gleam/dynamic/decode
import gleam/json

pub type User {
  User(username: String, email: String, password: String)
}

pub fn encoder(user: User) -> json.Json {
  json.object([
    #("username", json.string(user.username)),
    #("email", json.string(user.email)),
  ])
}

pub fn decoder() -> decode.Decoder(User) {
  use username <- decode.field("username", decode.string)
  use password <- decode.field("password", decode.string)
  use email <- decode.field("email", decode.string)
  decode.success(User(username:, password:, email:))
}
