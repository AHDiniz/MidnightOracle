//// Ref: https://github.com/gleam-wisp/wisp/blob/main/examples/src/hello_world/app/router.gleam

import server/middleware
import wisp.{type Request, type Response}

/// The HTTP request handler- your application!
pub fn handle_request(req: Request) -> Response {
  // Apply the middleware stack for this request/response.
  use _req <- middleware.middleware(req)

  // Later we'll use templates, but for now a string will do.
  let body = "{\"hello\": \"world\"}"

  wisp.json_response(body, 200)
}
