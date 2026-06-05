//// Utilitários genéricos para a xmlm

import gleam/result
import xmlm.{type Input, Data, Dtd, ElementEnd, ElementStart, Name, Tag}

/// Utilitário para evitar a repetição de
/// ```gleam
/// result.try(xmlm.signal(input) |> result.map_error(xmlm.input_error_to_string))
/// ```
pub fn try_signal(input: Input, callback: fn(_) -> Result(_, _)) {
  use x <- result.try(
    xmlm.signal(input) |> result.map_error(xmlm.input_error_to_string),
  )
  callback(x)
}

/// Pula o DTD do XML. Geralmente é encontrado apenas no início
pub fn consume_dtd(input: Input) -> Result(Input, _) {
  case xmlm.signal(input) {
    Ok(#(Dtd(_), input)) -> Ok(input)
    _ -> Error("DTD não encontrado")
  }
}

/// Consome `Data`s até consumir um ElementStart com a tag esperada
pub fn consume_data_until_element(
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
pub fn skip_until_element_end(input: Input) -> Result(Input, _) {
  case xmlm.signal(input) {
    Ok(#(ElementEnd, input)) -> Ok(input)

    Ok(#(ElementStart(_), input)) ->
      skip_until_element_end(input)
      |> result.try(skip_until_element_end)

    Ok(#(_, input)) -> skip_until_element_end(input)
    Error(x) -> Error(xmlm.input_error_to_string(x))
  }
}

/// Checa se a input do XML chegou ao fim ou se continuar a leitura gera erro
pub fn eoi_or_error(input: Input) -> Bool {
  xmlm.eoi(input)
  |> result.map(fn(x) { x.0 })
  |> result.unwrap(or: True)
}
