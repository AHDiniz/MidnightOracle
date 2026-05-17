import apps/auth/errors.{type AuthError}
import gleam/dynamic/decode
import gleam/json.{type Json}
import gleam/result
import gleam/string_tree
import wisp.{type Request, type Response}

pub fn decode_json_body(
  request: Request,
  decoder: decode.Decoder(a),
  next: fn(Result(a, AuthError)) -> Response,
) {
  use body <- wisp.require_json(request)
  let decoded =
    decode.run(body, decoder)
    |> result.map_error(fn(_) { errors.BadRequest })
  next(decoded)
}

pub fn fast_to_string(json: Json) -> String {
  json.to_string_tree(json)
  |> string_tree.to_string()
}

pub fn fast_json_response(
  fields: List(#(String, Json)),
  code: Int,
) -> Response {
  json.object(fields)
  |> fast_to_string()
  |> wisp.json_response(code)
}
