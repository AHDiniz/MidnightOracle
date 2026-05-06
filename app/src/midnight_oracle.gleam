import lustre
import lustre/effect
import lustre/element.{text}
import lustre/element/html as html
import messages

fn init() {
  #(Nil, effect.none())
}

fn update(model, message) {
  case message {
    Message(username, password) -> #(Nil, effect.none())
  }
}

fn view(model) {
  html.div([], [text("Hello, World!!!")])
}

pub fn main() {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "div", Nil)

  Nil
}
