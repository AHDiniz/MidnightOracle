import apps/auth
import apps/feed/service as feed_service
import apps/feed/utils
import apps/feed/xml/item as xml_item
import apps/utils as json_utils
import apps/utils/errors
import gleam/http
import gleam/json
import gleam/list
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
    _ -> wisp.not_found()
  }
}

fn list_items(req: Request, feed_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  use rss_url <- errors.try_response(feed_service.get_feed_url(user_id, feed_id))
  use rss_response <- errors.try_response(utils.get_request(rss_url))

  use items <- errors.try_response(
    xml_item.get_feed_items(rss_response.body) |> errors.to_bad_request(),
  )

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
