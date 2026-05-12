import gleam/dynamic/decode
import gleam/http
import gleam/json
import gleam/result
import midnight_domain/user
import wisp.{type Request, type Response}

fn register(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use body <- wisp.require_json(req)

  let result = {
    use res <- result.map(decode.run(body, user.decoder()))

    json.to_string(user.encoder(res))
  }

  case result {
    Ok(x) -> wisp.json_response(x, 200)
    Error(_) -> wisp.bad_request("Invalid body")
  }
}

// fn login(req: Request) -> Response {
//   todo
// }

pub fn router(req: Request, path: List(String)) -> Response {
  case path {
    ["register"] -> register(req)
    // ["login"] -> login(req)
    _ -> wisp.not_found()
  }
}
