import gleam/http/request

/// Cria uma request apontando para o host correto,
/// com o token de autorização configurado
pub fn build_authorized_request(token: String) -> request.Request(String) {
  request.new()
  |> request.set_host("http://127.0.0.1:8910")
  |> request.set_header("authorization", "Bearer " <> token)
}
