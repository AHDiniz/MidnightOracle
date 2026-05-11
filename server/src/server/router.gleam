//// Ref: https://github.com/gleam-wisp/wisp/blob/main/examples/src/hello_world/app/router.gleam

import server/middleware
import wisp.{type Request, type Response}

/// The HTTP request handler- your application!
pub fn handle_request(req: Request) -> Response {
  // Apply the middleware stack for this request/response.
  use req <- middleware.middleware(req)

  let #(body, status) = case wisp.path_segments(req) {
    [] -> #("{\"hello\": \"home\"}", 200)
    [seg] -> #("{\"hello\": \"" <> seg <> "\"}", 200)
    _ -> #("{\"hello\": \"nowhere\"}", 400)
  }

  wisp.json_response(body, status)
}
