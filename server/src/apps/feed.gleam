import apps/auth
import apps/auth/errors
import apps/feed/service
import apps/utils
import gleam/dynamic/decode
import gleam/http
import gleam/result
import wisp.{type Request, type Response}

pub fn create_feed(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use user_id <- auth.require_auth(req)

  let decoder = {
    use feed_url <- decode.field("feed_url", decode.string)
    decode.success(feed_url)
  }
  use decoded <- utils.decode_json_body(req, decoder)

  let res = {
    use feed_url <- result.try(decoded)
    service.create_feed_from_url(feed_url, user_id)
  }

  case res {
    Ok(_) -> wisp.json_response("{}", 201)
    Error(err) -> errors.error_response(err)
  }
}

pub fn router(req: Request, path: List(String)) -> Response {
  case path {
    ["create"] -> create_feed(req)
    _ -> wisp.not_found()
  }
}
