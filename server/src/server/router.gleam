//// Ref: https://github.com/gleam-wisp/wisp/blob/main/examples/src/routing/app/router.gleam

import apps/auth
import apps/category
import apps/feed
import server/middleware
import wisp.{type Request, type Response}

/// The HTTP request handler- your application!
pub fn handle_request(req: Request) -> Response {
  // Apply the middleware stack for this request/response.
  use req <- middleware.middleware(req)

  case wisp.path_segments(req) {
    [] -> wisp.json_response("{\"hello\": \"world\"}", 200)
    ["ping"] -> wisp.json_response("{\"ping\": \"pong\"}", 200)

    ["auth", ..path] -> auth.router(req, path)
    ["feed", ..path] -> feed.router(req, path)
    ["category", ..path] -> category.router(req, path)

    _ -> wisp.not_found()
  }
}
