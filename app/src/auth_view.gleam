import lustre/attribute as attr
import lustre/element.{text}
import lustre/element/html
import lustre/event
import messages as msg

pub fn login_form(model: msg.Model) -> element.Element(msg.Message) {
  let user = model.user

  html.form([], [
    html.div([], [
      html.input([
        attr.type_("text"),
        attr.value(user.username),
        event.on_input(msg.SetUserName),
      ]),
    ]),
    html.div([], [
      html.input([
        attr.type_("password"),
        attr.value(user.password),
        event.on_input(msg.SetPassword),
      ]),
    ]),
    html.div([], [html.button([event.on_click(msg.UserLogin)], [text("Login")])]),
    html.div([], [
      html.button([event.on_click(msg.GoToPage(msg.Register))], [
        text("Register"),
      ]),
    ]),
  ])
}

pub fn register_form(model: msg.Model) -> element.Element(msg.Message) {
  let user = model.user

  html.form([], [
    html.div([], [
      html.input([
        attr.type_("text"),
        attr.value(user.username),
        event.on_input(msg.SetUserName),
      ]),
    ]),
    html.div([], [
      html.input([
        attr.type_("text"),
        attr.value(user.email),
        event.on_input(msg.SetUserEmail),
      ]),
    ]),
    html.div([], [
      html.input([
        attr.type_("password"),
        attr.value(user.password),
        event.on_input(msg.SetPassword),
      ]),
    ]),
    html.div([], [
      html.button([event.on_click(msg.UserRegister)], [text("Register")]),
    ]),
    html.div([], [
      html.button([event.on_click(msg.GoToPage(msg.Login))], [
        text("Login"),
      ]),
    ]),
  ])
}
