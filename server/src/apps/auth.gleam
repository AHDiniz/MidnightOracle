import apps/auth/service
import apps/auth/token
import apps/utils
import apps/utils/errors
import gleam/bit_array
import gleam/dynamic/decode
import gleam/http
import gleam/json
import gleam/list
import gleam/result
import midnight_domain/user
import wisp.{type Request, type Response}

fn register(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use user <- utils.decode_json_body(req, user.decoder())

  use _ <- errors.try_response(service.persist_user(user))

  wisp.json_response("{}", 201)
}

fn authenticate(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)

  let body_decoder = {
    use username <- decode.field("username", decode.string)
    use password <- decode.field("password", decode.string)
    decode.success(#(username, password))
  }
  use #(username, password) <- utils.decode_json_body(req, body_decoder)

  use token <- errors.try_response(service.authenticate_user(username, password))

  [#("bearer_token", json.string(token))]
  |> utils.fast_json_response(200)
}

fn user(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)
  use user_id <- require_auth(req)

  use user <- errors.try_response(service.get_user(user_id))

  user
  |> user.encoder()
  |> utils.fast_to_string()
  |> wisp.json_response(200)
}

pub fn router(req: Request, path: List(String)) -> Response {
  case path {
    ["register"] -> register(req)
    ["login"] -> authenticate(req)
    ["me"] -> user(req)
    _ -> wisp.not_found()
  }
}

/// The input for the callback is the id of the authenticated user
pub fn require_auth(
  req: wisp.Request,
  next: fn(Int) -> wisp.Response,
) -> wisp.Response {
  let header_result =
    req.headers
    |> list.key_find("authorization")

  let read_token_result = {
    use header <- result.try(header_result)
    let token_res = case header {
      "Bearer " <> token -> Ok(token)
      _ -> Error(Nil)
    }

    use token_str <- result.try(token_res)
    bit_array.base64_decode(token_str)
  }

  let res = {
    use token_bit <- result.try(read_token_result |> errors.to_unauthorized())
    token.get_user_by_token(token_bit)
  }

  errors.try_response(res, next)
}
