import lustre/attribute as attr
import lustre/element.{text}
import lustre/element/html
import lustre/event
import messages as msg
import utils

pub fn app_wrapper(
  model: msg.Model,
  content: element.Element(msg.Message),
) -> element.Element(msg.Message) {
  html.div(app_attributes(), [
    navbar(model),
    content,
  ])
}

fn navbar(model: msg.Model) -> element.Element(msg.Message) {
  let content = case model.token {
    "" -> {
      [
        utils.app_link("Login", msg.GoToPage(msg.Login)),
        utils.app_link("Register", msg.GoToPage(msg.Register)),
      ]
    }
    _ -> {
      []
    }
  }
  html.div(
    [
      attr.class("flex flex-col gap-2 p-8"),
    ],
    content,
  )
}

fn app_attributes() -> List(attr.Attribute(msg.Message)) {
  [
    attr.class("flex flex-col gap-2 p-8"),
  ]
}
