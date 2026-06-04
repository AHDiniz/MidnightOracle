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
    [] -> namespace_routes(req)
    [head, ..tail] -> {
      case int.parse(head), tail {
        Ok(id), [] -> id_routes(req, id)
        _, _ -> wisp.not_found()
      }
    }
  }
}

fn namespace_routes(req: Request) -> Response {
  case req.method {
    http.Get -> list_feeds(req)
    http.Post -> create_feed(req)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn id_routes(req: Request, id: Int) -> Response {
  case req.method {
    http.Patch -> update_feed(req, id)
    http.Delete -> delete_feed(req, id)
    _ -> wisp.method_not_allowed([http.Patch, http.Delete])
  }
}

fn create_feed(req: Request) -> Response {
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
  use user_id <- auth.require_auth(req)

  let res = service.get_feeds_from_user(user_id)

  use feeds <- errors.try_response(res)

  feeds
  |> json.array(rss_feed.to_json)
  |> utils.fast_to_string()
  |> wisp.json_response(200)
}

pub fn update_feed(req: Request, feed_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  let update_res = service.update_feed_from_user(user_id, feed_id)
  use _ <- errors.try_response(update_res)

  wisp.json_response("{}", 200)
}

pub fn delete_feed(req: Request, feed_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  let delete_res = service.delete_feed_from_user(user_id, feed_id)
  use _ <- errors.try_response(delete_res)

  wisp.json_response("{}", 200)
}
