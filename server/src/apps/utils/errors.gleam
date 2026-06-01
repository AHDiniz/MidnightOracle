import gleam/option.{type Option}
import gleam/result
import wisp.{type Response}

pub type ServerError {
  WrongUser
  WrongPass
  BadRequest
  Unauthorized
  InternalError
}

/// Tipos de Result retornados por esse módulo, abstraindo erros internos
pub type ServerResult(s) =
  Result(s, ServerError)

pub fn to_internal_error(res: Result(a, _)) -> ServerResult(a) {
  result.replace_error(res, InternalError)
}

pub fn to_unauthorized(res: Result(a, _)) -> ServerResult(a) {
  result.replace_error(res, Unauthorized)
}

pub fn to_bad_request(res: Result(a, _)) -> ServerResult(a) {
  result.replace_error(res, BadRequest)
}

fn error_json_response(msg: String, code: Int) {
  wisp.json_response("{\"error\": \"" <> msg <> "\"}", code)
}

pub fn error_response(error: ServerError) -> Response {
  case error {
    BadRequest -> error_json_response("Body inválido", 400)
    WrongUser | WrongPass -> error_json_response("Credenciais inválidas", 400)
    Unauthorized -> error_json_response("Token inválido", 401)
    InternalError -> error_json_response("Erro interno", 500)
  }
}

pub fn unwrap_result_option(
  res_opt: Result(Option(a), _),
  none_fn: fn() -> ServerResult(a),
) -> ServerResult(a) {
  case res_opt {
    Ok(option.Some(x)) -> Ok(x)
    Ok(option.None) -> none_fn()
    Error(_) -> Error(InternalError)
  }
}

pub fn try_response(
  res: ServerResult(a),
  callback: fn(a) -> Response,
) -> Response {
  case res {
    Ok(val) -> callback(val)
    Error(err) -> error_response(err)
  }
}
