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
        Ok(item_id) -> {
          case req.method {
            http.Get -> list_item_categories(req, item_id)
            http.Post -> add_category_to_item(req, item_id)
            _ -> wisp.method_not_allowed([http.Get, http.Post])
          }
        }
        Error(_) -> wisp.not_found()
      }
    }
    [item_id, category_id] -> {
      case int.parse(item_id), int.parse(category_id) {
        Ok(item_id), Ok(category_id) -> {
          use <- wisp.require_method(req, http.Delete)
          remove_category_from_item(req, category_id, item_id)
        }
        _, _ -> wisp.not_found()
      }
    }
    _ -> wisp.not_found()
  }
}

fn list_item_categories(req: Request, item_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  use categories <- errors.try_response(service.list_categories_by_item(
    user_id,
    item_id,
  ))

  categories
  |> json.array(category.to_json)
  |> utils.fast_to_string
  |> wisp.json_response(200)
}

fn add_category_to_item(req: Request, item_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  let decoder = {
    use id <- decode.field("category_id", decode.int)
    decode.success(id)
  }
  use category_id <- utils.decode_json_body(req, decoder)

  use _ <- errors.try_response(service.add_category_to_item(
    user_id,
    category_id,
    item_id,
  ))

  wisp.json_response("{}", 201)
}

fn remove_category_from_item(
  req: Request,
  category_id: Int,
  item_id: Int,
) -> Response {
  use user_id <- auth.require_auth(req)

  use _ <- errors.try_response(service.remove_category_from_item(
    user_id,
    category_id,
    item_id,
  ))

  wisp.no_content()
}
