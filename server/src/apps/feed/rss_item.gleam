import apps/auth
import apps/feed/rss_item/service as item_service
import apps/feed/service as feed_service
import apps/utils as json_utils
import apps/utils/errors
import gleam/dynamic/decode
import gleam/http
import gleam/int
import gleam/json
import gleam/list
import midnight_domain/rss_item
import wisp.{type Request, type Response}

/// Router para as rotas relacionadas a Items
/// 
/// Diferente dos outros routers, recebe também um id, do Feed em questão
pub fn router(req: Request, feed_id: Int, path: List(String)) -> Response {
  case path {
    [] -> {
      case req.method {
        http.Get -> list_items(req, feed_id)
        _ -> wisp.method_not_allowed([http.Get])
      }
    }
    ["saved"] -> {
      case req.method {
        http.Get -> list_saved_items(req, feed_id)
        http.Post -> save_feed_item(req, feed_id)
        _ -> wisp.method_not_allowed([http.Get, http.Post])
      }
    }
    ["saved", id] -> {
      case int.parse(id) {
        Ok(id) -> {
          use <- wisp.require_method(req, http.Delete)
          delete_saved_item(req, feed_id, id)
        }
        _ -> wisp.not_found()
      }
    }
    _ -> wisp.not_found()
  }
}

fn list_items(req: Request, feed_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  use rss_url <- errors.try_response(feed_service.get_feed_url(user_id, feed_id))
  use items <- errors.try_response(item_service.read_feed_items_from_url(
    rss_url,
  ))

  items
  |> list.map(fn(fields) {
    [
      #("title", json.string(fields.title)),
      #("link", json.string(fields.link)),
      #("description", json.string(fields.description)),
      #("enclosure_url", json.string(fields.enclosure_url)),
    ]
  })
  |> json.array(json.object)
  |> json_utils.fast_to_string()
  |> wisp.json_response(200)
}

fn list_saved_items(req: Request, feed_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  use items <- errors.try_response(item_service.list_feed_saved_items(
    user_id,
    feed_id,
  ))

  items
  |> json.array(rss_item.to_json)
  |> json_utils.fast_to_string()
  |> wisp.json_response(200)
}

fn save_feed_item(req: Request, feed_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  let decoder = {
    use title <- decode.field("title", decode.string)
    use link <- decode.field("link", decode.string)
    use description <- decode.field("description", decode.string)
    use enclosure_url <- decode.field("enclosure_url", decode.string)

    decode.success(#(title, link, description, enclosure_url))
  }
  use #(title, link, description, enclosure_url) <- json_utils.decode_json_body(
    req,
    decoder,
  )

  use _ <- errors.try_response(item_service.save_feed_item(
    user_id,
    feed_id,
    title,
    link,
    description,
    enclosure_url,
  ))
  wisp.json_response("{}", 201)
}

fn delete_saved_item(req: Request, feed_id: Int, item_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  use _ <- errors.try_response(item_service.delete_saved_item(
    user_id,
    feed_id,
    item_id,
  ))

  wisp.no_content()
}
