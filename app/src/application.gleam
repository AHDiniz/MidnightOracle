import gleam/http
import gleam/http/request
import gleam/json
import midnight_domain/user.{type User, User}

pub type AuthError {
  CouldNotLogin
  CouldNotRegister
}

pub fn login_service(user: User) -> Result(User, AuthError) {
  let j =
    json.object([
      #("username", json.string(user.username)),
      #("password", json.string(user.password)),
    ])

  let r =
    request.new()
    |> request.set_host("localhost")
    |> request.set_port(8910)
    |> request.set_method(http.Get)
    |> request.set_path("auth/")
    |> request.set_body(json.to_string(j))

  let request_result = request.get_query(r)

  let service_result = case request_result {
    Error(Nil) -> {
      Error(CouldNotLogin)
    }
    Ok(data) -> {
      Ok(user)
    }
  }

  service_result
}

pub fn register_service(user: User) -> Result(User, AuthError) {
  Ok(user)
}
