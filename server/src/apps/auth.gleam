import apps/auth/utils
import gleam/dynamic/decode
import gleam/http
import gleam/result
import midnight_domain/user
import wisp.{type Request, type Response}

pub type AuthErrors {
  InternalError
  BadBody
}

fn register(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use body <- wisp.require_json(req)

  let result = {
    use user <- result.map(decode.run(body, user.decoder()))
    utils.persist_user(user)
  }

  case result {
    Ok(Ok(_)) -> wisp.json_response("{}", 201)
    Ok(Error(_)) -> utils.error_json_response("Erro interno", 500)
    Error(_) -> utils.error_json_response("Body inválido", 400)
  }
}

fn login(req: Request) -> Response {
  let body_decoder = {
    use username <- decode.field("username", decode.string)
    use password <- decode.field("password", decode.string)
    decode.success(#(username, password))
  }

  use <- wisp.require_method(req, http.Post)
  use body <- wisp.require_json(req)

  let validate_result = {
    use #(username, password) <- result.map(decode.run(body, body_decoder))
    utils.validate_user(username, password)
  }

  case validate_result {
    Ok(Ok(True)) -> wisp.accepted()
    Ok(Ok(False)) ->
      utils.error_json_response("Usuário ou senha incorretos", 400)
    Ok(Error(msg)) -> utils.error_json_response(msg, 500)
    Error(_) -> utils.error_json_response("Body inválido", 400)
  }
}

pub fn router(req: Request, path: List(String)) -> Response {
  case path {
    ["register"] -> register(req)
    ["login"] -> login(req)
    _ -> wisp.not_found()
  }
}
