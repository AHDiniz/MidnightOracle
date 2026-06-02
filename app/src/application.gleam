import gleam/http
import gleam/http/request
import gleam/json
import midnight_domain/user
import lustre/effect
import messages as msg

pub type AuthError {
  CouldNotLogin
  CouldNotRegister
}

pub fn login_service(user: user.User) -> Result(msg.ApiLoginResponse(user.User, Int), AuthError) {
  let j =
    json.object([
      #("username", json.string(user.username)),
      #("password", json.string(user.password)),
    ])

  let r =
    request.new()
    |> request.set_host("localhost")
    |> request.set_port(8910)
    |> request.set_method(http.Post)
    |> request.set_path("auth/login")
    |> request.set_body(json.to_string(j))

  let request_result = request.get_query(r)

  let service_result = case request_result {
    Error(Nil) -> {
      Error(CouldNotLogin)
    }
    Ok(data) -> {
      Ok(msg.ApiLoginResponse(user: user, token: -1))
    }
  }

  service_result
}

pub fn register_service(user: user.User) -> Result(msg.ApiRegisterResponse(user.User, Int), AuthError) {
  let j =
    json.object([
      #("username", json.string(user.username)),
      #("password", json.string(user.password)),
      #("email", json.string(user.email)),
    ])

  let r =
    request.new()
    |> request.set_host("localhost")
    |> request.set_port(8910)
    |> request.set_method(http.Post)
    |> request.set_path("auth/register")
    |> request.set_body(json.to_string(j))

  let request_result = request.get_query(r)

  let service_result = case request_result {
    Error(Nil) -> {
      Error(CouldNotRegister)
    }
    Ok(data) -> {
      Ok(msg.ApiRegisterResponse(user: user, token: -1))
    }
  }

  service_result
}
