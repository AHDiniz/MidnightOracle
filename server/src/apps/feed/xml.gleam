import gleam/bool
import gleam/result
import xmlm.{type Input, Data, Dtd, ElementEnd, ElementStart, Name, Tag}

pub fn get_feed_fields(xml_string: String) -> Result(_, _) {
  let xml_input = xmlm.from_string(xml_string)

  use input <- result.try(consume_dtd(xml_input))
  use input <- result.try(consume_data_until_element(input, "rss"))
  use input <- result.try(consume_data_until_element(input, "channel"))

  use builder <- result.try(build_feed_from_channel_content(
    input,
    empty_builder(),
  ))

  echo builder_to_fields(builder)
}

// Utilitários para construir o RssFeed a partir do XML
type RssFeedBuilder {
  RssFeedBuilder(
    feed_url: Result(String, String),
    feed_title: Result(String, String),
    feed_description: Result(String, String),
    pub_date: String,
    last_build: String,
    image_url: String,
  )
}

pub type RssFeedFields {
  RssFeedFields(
    feed_url: String,
    feed_title: String,
    feed_description: String,
    pub_date: String,
    last_build: String,
    image_url: String,
  )
}

fn empty_builder() -> RssFeedBuilder {
  RssFeedBuilder(
    Error("Sem url"),
    Error("Sem title"),
    Error("Sem description"),
    "",
    "",
    "",
  )
}

fn builder_to_fields(builder: RssFeedBuilder) -> Result(RssFeedFields, String) {
  use feed_url <- result.try(builder.feed_url)
  use feed_title <- result.try(builder.feed_title)
  use feed_description <- result.try(builder.feed_description)

  Ok(RssFeedFields(
    feed_url,
    feed_title,
    feed_description,
    builder.pub_date,
    builder.last_build,
    builder.image_url,
  ))
}

fn build_feed_from_channel_content(
  input: Input,
  rss_builder: RssFeedBuilder,
) -> Result(RssFeedBuilder, _) {
  let eoi =
    xmlm.eoi(input)
    |> result.map(fn(x) { x.0 })
    |> result.unwrap(or: False)
  use <- bool.guard(when: eoi, return: Ok(rss_builder))

  use #(signal, new_input) <- try_signal(input)

  case signal {
    Data(_) | Dtd(_) | ElementEnd ->
      build_feed_from_channel_content(new_input, rss_builder)

    ElementStart(tag) -> {
      case tag.name.local {
        // Processar os elementos que nos importam
        "link" | "title" | "description" | "pubDate" | "lastBuildDate" -> {
          use #(signal, new_input) <- try_signal(new_input)

          case signal {
            Data(value) -> {
              let new_builder =
                update_builder_field(rss_builder, tag.name.local, value)
              build_feed_from_channel_content(new_input, new_builder)
            }
            _ -> build_feed_from_channel_content(new_input, rss_builder)
          }
        }
        // Skippar os elementos que não importam
        _ -> {
          use new_input <- result.try(skip_until_element_end(new_input))
          build_feed_from_channel_content(new_input, rss_builder)
        }
      }
    }
  }
}

fn update_builder_field(
  builder: RssFeedBuilder,
  xml_elem: String,
  val: String,
) -> RssFeedBuilder {
  case xml_elem {
    "link" -> RssFeedBuilder(..builder, feed_url: Ok(val))
    "title" -> RssFeedBuilder(..builder, feed_title: Ok(val))
    "description" -> RssFeedBuilder(..builder, feed_description: Ok(val))
    "pubDate" -> RssFeedBuilder(..builder, pub_date: val)
    "lastBuildDate" -> RssFeedBuilder(..builder, last_build: val)
    _ -> builder
  }
}

// Utilitários genéricos para a xmlm

/// Utilitário para evitar a repetição de
/// ```gleam
/// result.try(xmlm.signal(input) |> result.map_error(xmlm.input_error_to_string))
/// ```
fn try_signal(input: Input, callback: fn(_) -> _) {
  use x <- result.try(
    xmlm.signal(input) |> result.map_error(xmlm.input_error_to_string),
  )
  callback(x)
}

/// Pula o DTD do XML. Geralmente é encontrado apenas no início
fn consume_dtd(input: Input) -> Result(Input, _) {
  case xmlm.signal(input) {
    Ok(#(Dtd(_), input)) -> Ok(input)
    _ -> Error("DTD não encontrado")
  }
}

/// Consome `Data`s até consumir um ElementStart com a tag esperada
fn consume_data_until_element(
  input: Input,
  tag_name: String,
) -> Result(Input, _) {
  case xmlm.signal(input) {
    Ok(#(ElementStart(Tag(Name(_, name), _)), new_input)) if tag_name == name ->
      Ok(new_input)
    Ok(#(Data(_), new_input)) -> consume_data_until_element(new_input, tag_name)
    _ -> Error("Erro consumindo elemento")
  }
}

/// Pula elementos até encontrar um ElementEnd.
/// 
/// Também pula aninhadamente ElementEnd's para cada
/// ElementStart encontrado no meio do caminho
fn skip_until_element_end(input: Input) -> Result(Input, _) {
  case xmlm.signal(input) {
    Ok(#(ElementEnd, input)) -> Ok(input)

    Ok(#(ElementStart(_), input)) ->
      skip_until_element_end(input)
      |> result.try(skip_until_element_end)

    Ok(#(_, input)) -> skip_until_element_end(input)
    Error(x) -> Error(xmlm.input_error_to_string(x))
  }
}
