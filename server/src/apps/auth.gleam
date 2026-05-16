import apps/auth/errors
import apps/auth/service
import apps/utils
import gleam/dynamic/decode
import gleam/http
import gleam/json
import gleam/result
import midnight_domain/user
import wisp.{type Request, type Response}

fn register(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use decoded <- utils.decode_json_body(req, user.decoder())

  let res = {
    use user <- result.try(decoded)
    service.persist_user(user)
  }

  case res {
    Ok(_) -> wisp.json_response("{}", 201)
    Error(err) -> errors.error_response(err)
  }
}

fn login(req: Request) -> Response {
  let body_decoder = {
    use username <- decode.field("username", decode.string)
    use password <- decode.field("password", decode.string)
    decode.success(#(username, password))
  }

  use <- wisp.require_method(req, http.Post)
  use decoded <- utils.decode_json_body(req, body_decoder)

  let auth_result = {
    use #(username, password) <- result.try(decoded)
    service.authenticate_user(username, password)
  }

  case auth_result {
    Ok(token) -> {
      [#("bearer_token", json.string(token))]
      |> utils.fast_json_response(200)
    }
    Error(x) -> errors.error_response(x)
  }
}

pub fn router(req: Request, path: List(String)) -> Response {
  case path {
    ["register"] -> register(req)
    ["login"] -> login(req)
    _ -> wisp.not_found()
  }
}
