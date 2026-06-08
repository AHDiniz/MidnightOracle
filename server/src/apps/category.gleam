import apps/auth
import apps/category/feed_category
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
    [] -> {
      case req.method {
        http.Get -> list_user_categories(req)
        http.Post -> create_category(req)
        _ -> wisp.method_not_allowed([http.Get, http.Post])
      }
    }
    [id] -> {
      case int.parse(id) {
        Ok(category_id) -> {
          use <- wisp.require_method(req, http.Delete)
          delete_category(req, category_id)
        }
        _ -> wisp.not_found()
      }
    }
    ["feed", ..path] -> feed_category.router(req, path)
    _ -> wisp.not_found()
  }
}

fn list_user_categories(req: Request) -> Response {
  use user_id <- auth.require_auth(req)

  use categories <- errors.try_response(service.list_categories_by_user(user_id))

  categories
  |> json.array(category.to_json)
  |> utils.fast_to_string
  |> wisp.json_response(200)
}

fn create_category(req: Request) -> Response {
  use user_id <- auth.require_auth(req)

  let decoder = {
    use name <- decode.field("name", decode.string)
    decode.success(name)
  }
  use name <- utils.decode_json_body(req, decoder)

  use _ <- errors.try_response(service.create_category(user_id, name))
  wisp.json_response("{}", 200)
}

fn delete_category(req: Request, category_id: Int) -> Response {
  use user_id <- auth.require_auth(req)

  use _ <- errors.try_response(service.delete_category(user_id, category_id))

  wisp.no_content()
}
