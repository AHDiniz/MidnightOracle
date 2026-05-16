import gleam/result
import wisp.{type Response}

pub type AuthError {
  WrongUser
  WrongPass
  BadRequest
  Unauthorized
  InternalError
}

/// Tipos de Result retornados por esse módulo, abstraindo erros internos
pub type AuthResult(s) =
  Result(s, AuthError)

fn error_json_response(msg: String, code: Int) {
  wisp.json_response("{\"error\": \"" <> msg <> "\"}", code)
}

pub fn error_response(error: AuthError) -> Response {
  case error {
    InternalError -> error_json_response("Erro interno", 500)
    BadRequest -> error_json_response("Body inválido", 400)
    WrongUser | WrongPass -> error_json_response("Credenciais inválidas", 400)
    Unauthorized -> error_json_response("Token inválido", 401)
  }
}

pub fn to_internal_error(res: Result(a, _)) -> AuthResult(a) {
  result.map_error(res, fn(_) { InternalError })
}
