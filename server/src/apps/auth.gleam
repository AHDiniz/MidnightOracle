import apps/auth/errors
import apps/auth/service
import apps/auth/token
import apps/utils
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

fn authenticate(req: Request) -> Response {
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

fn user(req: Request) -> Response {
  use user_id <- require_auth(req)

  case service.get_user(user_id) {
    Ok(user) ->
      user.encoder(user)
      |> utils.fast_to_string()
      |> wisp.json_response(200)
    Error(err) -> errors.error_response(err)
  }
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

  let token_result = {
    use header <- result.try(header_result)
    let token_res = case header {
      "Bearer " <> token -> Ok(token)
      _ -> Error(Nil)
    }

    use token_str <- result.try(token_res)
    bit_array.base64_decode(token_str)
  }

  let res = {
    use token_bit <- result.try(
      result.map_error(token_result, fn(_) { errors.Unauthorized }),
    )
    token.get_user_by_token(token_bit)
  }

  case res {
    Ok(id) -> next(id)
    Error(x) -> errors.error_response(x)
  }
}
