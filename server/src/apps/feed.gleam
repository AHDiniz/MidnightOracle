import apps/auth
import apps/feed/service
import apps/utils
import apps/utils/errors
import gleam/dynamic/decode
import gleam/http
import gleam/json
import gleam/result
import midnight_domain/rss_feed
import wisp.{type Request, type Response}

fn create_feed(req: Request) -> Response {
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

fn list_feeds(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)
  use user_id <- auth.require_auth(req)

  let res = service.get_feeds_from_user(user_id)

  use feeds <- errors.try_response(res)

  feeds
  |> json.array(rss_feed.encoder)
  |> json.to_string()
  |> wisp.json_response(200)
}

pub fn router(req: Request, path: List(String)) -> Response {
  case path {
    ["create"] -> create_feed(req)
    ["list"] -> list_feeds(req)
    _ -> wisp.not_found()
  }
}
