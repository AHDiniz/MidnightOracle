import lustre/attribute as attr
import lustre/element.{text}
import lustre/element/html
import lustre/event
import messages as msg
import utils

pub fn login_form(model: msg.Model) -> element.Element(msg.Message) {
  let user = model.user

  html.div([attr.class("flex flex-col gap-2 p-8")], [
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
      html.div([], [utils.app_button("Login", msg.UserLogin)]),
    ]),
    html.div([], [utils.app_link("Register", msg.GoToPage(msg.Register))]),
  ])
}

pub fn register_form(model: msg.Model) -> element.Element(msg.Message) {
  let user = model.user

  html.div([attr.class("flex flex-col gap-2 p-8")], [
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
      html.div([], [utils.app_button("Register", msg.UserRegister)]),
    ]),
    html.div([], [utils.app_link("Login", msg.GoToPage(msg.Login))]),
  ])
}
