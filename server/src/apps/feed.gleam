import apps/auth
import apps/feed/service
import apps/utils
import apps/utils/errors
import gleam/dynamic/decode
import gleam/http
import gleam/int
import gleam/json
import midnight_domain/rss_feed
import wisp.{type Request, type Response}

pub fn router(req: Request, path: List(String)) -> Response {
  case path {
    ["create"] -> create_feed(req)
    ["list"] -> list_feeds(req)
    ["update"] -> update_feed(req)
    ["delete", id] -> delete_feed(req, id)
    _ -> wisp.not_found()
  }
}

fn create_feed(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use user_id <- auth.require_auth(req)

  let decoder = {
    use feed_url <- decode.field("feed_url", decode.string)
    decode.success(feed_url)
  }
  use decoded <- utils.decode_json_body(req, decoder)
  use feed_url <- errors.try_response(decoded)

  let create_res = service.create_feed_from_url(feed_url, user_id)
  use _ <- errors.try_response(create_res)

  wisp.json_response("{}", 201)
}

fn list_feeds(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)
  use user_id <- auth.require_auth(req)

  let res = service.get_feeds_from_user(user_id)

  use feeds <- errors.try_response(res)

  feeds
  |> json.array(rss_feed.to_json)
  |> utils.fast_to_string()
  |> wisp.json_response(200)
}

pub fn update_feed(req: Request) -> Response {
  use <- wisp.require_method(req, http.Post)
  use user_id <- auth.require_auth(req)

  let decoder = {
    use feed_id <- decode.field("feed_id", decode.int)
    decode.success(feed_id)
  }
  use decoded <- utils.decode_json_body(req, decoder)
  use feed_id <- errors.try_response(decoded)

  let update_res = service.update_feed_from_user(user_id, feed_id)
  use _ <- errors.try_response(update_res)

  wisp.json_response("{}", 200)
}

pub fn delete_feed(req: Request, id: String) -> Response {
  use <- wisp.require_method(req, http.Delete)
  use user_id <- auth.require_auth(req)

  use feed_id <- errors.try_response(int.parse(id) |> errors.to_bad_request())

  let delete_res = service.delete_feed_from_user(user_id, feed_id)
  use _ <- errors.try_response(delete_res)

  wisp.no_content()
}
