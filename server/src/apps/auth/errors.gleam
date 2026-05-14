import gleam/result
import wisp.{type Response}

pub type AuthError {
  InternalError
  BadRequest
  WrongUser
  WrongPass
}

fn error_json_response(msg: String, code: Int) {
  wisp.json_response("{\"error\": \"" <> msg <> "\"}", code)
}

pub fn error_response(error: AuthError) -> Response {
  case error {
    InternalError -> error_json_response("Erro interno", 500)
    BadRequest -> error_json_response("Body inválido", 400)
    WrongUser | WrongPass -> error_json_response("Credenciais inválidas", 400)
  }
}

pub fn to_internal_error(res: Result(a, _)) -> Result(a, AuthError) {
  result.map_error(res, fn(_) { InternalError })
}
