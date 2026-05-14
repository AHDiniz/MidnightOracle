import apps/auth/errors.{type AuthError}
import gleam/dynamic/decode
import gleam/result
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
