import apps/auth
import apps/category/service
import apps/utils
import apps/utils/errors
import gleam/dynamic/decode
import gleam/http
import gleam/int
import gleam/json
import midnight_domain/category
import wisp.{type Request, type Response}

pub fn router(req: Request, path: List(String)) -> Response {
  case path {
    [id] -> {
      case int.parse(id) {
        Ok(feed_id) -> {
          case req.method {
            http.Get -> list_feed_categories(req, feed_id)
            http.Post -> add_category_to_feed(req, feed_id)
            _ -> wisp.method_not_allowed([http.Get, http.Post])
          }
        }
        Error(_) -> wisp.not_found()
      }
    }
    [feed_id, category_id] -> {
      case int.parse(feed_id), int.parse(category_id) {
        Ok(feed_id), Ok(category_id) -> {
          use <- wisp.require_method(req, http.Delete)
          remove_category_from_feed(req, category_id, feed_id)
        }
        _, _ -> wisp.not_found()
      }
    }
    _ -> wisp.not_found()
  }
}

fn list_feed_categories(req: Request, feed_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  use categories <- errors.try_response(service.list_categories_by_feed(
    user_id,
    feed_id,
  ))

  categories
  |> json.array(category.to_json)
  |> utils.fast_to_string
  |> wisp.json_response(200)
}

fn add_category_to_feed(req: Request, feed_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  let decoder = {
    use id <- decode.field("category_id", decode.int)
    decode.success(id)
  }
  use category_id <- utils.decode_json_body(req, decoder)

  use _ <- errors.try_response(service.add_category_to_feed(
    user_id,
    category_id,
    feed_id,
  ))

  wisp.json_response("{}", 201)
}

fn remove_category_from_feed(
  req: Request,
  category_id: Int,
  feed_id: Int,
) -> Response {
  use user_id <- auth.require_auth(req)

  use _ <- errors.try_response(service.remove_category_from_feed(
    user_id,
    category_id,
    feed_id,
  ))

  wisp.no_content()
}
