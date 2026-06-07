import lustre/attribute as attr
import lustre/element.{text}
import lustre/element/html
import lustre/event
import messages as msg

pub fn app_link(
  name: String,
  on_click: msg.Message,
) -> element.Element(msg.Message) {
  html.a(
    [
      event.on_click(on_click),
      attr.class(
        "border-purple-200 text-purple-600 hover:border-transparent hover:bg-purple-600 hover:text-white active:bg-purple-700",
      ),
    ],
    [
      text(name),
    ],
  )
}

pub fn app_button(
  name: String,
  on_click: msg.Message,
) -> element.Element(msg.Message) {
  html.button(
    [
      event.on_click(on_click),
      attr.class(
        "border-purple-200 text-purple-600 hover:border-transparent hover:bg-purple-600 hover:text-white active:bg-purple-700",
      ),
    ],
    [
      text(name),
    ],
  )
}
