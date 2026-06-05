import apps/feed/xml/utils
import gleam/bool
import gleam/list
import gleam/result
import xmlm.{type Input, Data, Dtd, ElementEnd, ElementStart}

pub fn get_feed_items(
  xml_string: String,
) -> Result(List(RssItemFields), String) {
  let xml_input = xmlm.from_string(xml_string)

  use input <- result.try(utils.consume_dtd(xml_input))
  use input <- result.try(utils.consume_data_until_element(input, "rss"))
  use input <- result.try(utils.consume_data_until_element(input, "channel"))

  build_items_from_channel_content(input, []) |> result.map(list.reverse)
}

pub type RssItemFields {
  RssItemFields(
    title: String,
    link: String,
    description: String,
    enclosure_url: String,
  )
}

fn empty_fields() -> RssItemFields {
  RssItemFields("", "", "", "")
}

/// Como os elementos são lidos do primeiro ao último, mas listas funcionais são
/// basicamente pilhas (adição no início), o retorna será na ordem contrária do XML
fn build_items_from_channel_content(
  input: Input,
  acc: List(RssItemFields),
) -> Result(List(RssItemFields), _) {
  let end = utils.eoi_or_error(input)
  use <- bool.guard(when: end, return: Ok(acc))

  use #(signal, new_input) <- utils.try_signal(input)

  case signal {
    Data(_) | Dtd(_) | ElementEnd ->
      build_items_from_channel_content(new_input, acc)

    ElementStart(tag) -> {
      case tag.name.local {
        // Processar os elementos que nos importam
        "item" -> {
          use #(new_fields, new_input) <- result.try(
            build_item_from_item_content(new_input, empty_fields()),
          )
          build_items_from_channel_content(new_input, [new_fields, ..acc])
        }
        // Skippar os elementos que não importam
        _ -> {
          use new_input <- result.try(utils.skip_until_element_end(new_input))
          build_items_from_channel_content(new_input, acc)
        }
      }
    }
  }
}

fn build_item_from_item_content(
  input: Input,
  fields: RssItemFields,
) -> Result(#(RssItemFields, Input), _) {
  use #(signal, new_input) <- utils.try_signal(input)

  case signal {
    // Final do elemento `item` que fez entrar aqui
    ElementEnd -> Ok(#(fields, new_input))

    // Informação ignorável
    Data(_) | Dtd(_) -> build_item_from_item_content(new_input, fields)

    ElementStart(tag) -> {
      case tag.name.local {
        // Processar os elementos que nos importam
        "link" | "title" | "description" | "enclosure" -> {
          use #(signal, new_input) <- utils.try_signal(new_input)

          case signal {
            Data(value) -> {
              let new_fields = update_field(fields, tag.name.local, value)
              use new_input <- result.try(utils.skip_until_element_end(
                new_input,
              ))
              build_item_from_item_content(new_input, new_fields)
            }
            _ -> build_item_from_item_content(new_input, fields)
          }
        }
        // Skippar os elementos que não importam
        _ -> {
          use new_input <- result.try(utils.skip_until_element_end(new_input))
          build_item_from_item_content(new_input, fields)
        }
      }
    }
  }
}

fn update_field(
  fields: RssItemFields,
  xml_elem: String,
  value: String,
) -> RssItemFields {
  case xml_elem {
    "link" -> RssItemFields(..fields, link: value)
    "title" -> RssItemFields(..fields, title: value)
    "description" -> RssItemFields(..fields, description: value)
    "enclosure" -> RssItemFields(..fields, enclosure_url: value)
    _ -> fields
  }
}
