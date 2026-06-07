import gleam/json

pub type Category {
  Category(id: Int, name: String)
}

pub fn to_json(category: Category) -> json.Json {
  let Category(id:, name:) = category
  json.object([
    #("id", json.int(id)),
    #("name", json.string(name)),
  ])
}
