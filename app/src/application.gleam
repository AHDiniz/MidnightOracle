import gleam/dynamic/decode
import gleam/json
import lustre/effect
import messages as msg
import midnight_domain/user
import rsvp

pub type AuthError {
  CouldNotLogin
  CouldNotRegister
}

pub fn login_service(user: user.User) -> effect.Effect(msg.Message) {
  let url = "http://localhost:8910/auth/login"
  let body =
    json.object([
      #("username", json.string(user.username)),
      #("password", json.string(user.password)),
    ])
  let handler = rsvp.expect_json(token_decoder(), msg.ApiLoginRequest)
  rsvp.post(url, body, handler)
}

pub fn register_service(user: user.User) -> effect.Effect(msg.Message) {
  let url = "http://localhost:8910/auth/register"
  let body =
    json.object([
      #("username", json.string(user.username)),
      #("password", json.string(user.password)),
      #("email", json.string(user.email)),
    ])
  let handler = rsvp.expect_ok_response(msg.ApiRegisterRequest)
  rsvp.post(url, body, handler)
}

fn token_decoder() {
  use token <- decode.field("bearer_token", decode.string)
  decode.success(token)
}
