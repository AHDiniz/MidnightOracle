import gleam/http/response
import midnight_domain/rss_feed
import midnight_domain/rss_item
import midnight_domain/user
import rsvp

pub type Page {
  Index
  Login
  Register
  Error
  Feed
  Item
}

pub type Model {
  Model(user: user.User, token: String, current_page: Page)
}

pub type Message {
  SetUserName(username: String)
  SetUserEmail(email: String)
  SetPassword(password: String)
  UserLogin
  UserRegister
  GoToPage(page: Page)
  ApiLoginRequest(result: Result(String, rsvp.Error(String)))
  ApiRegisterRequest(
    result: Result(response.Response(String), rsvp.Error(String)),
  )
  // Feed Messages
  CreateFeedRequest(
    result: Result(response.Response(String), rsvp.Error(String)),
  )
  ListFeedRequest(result: Result(List(rss_feed.RssFeed), rsvp.Error(String)))
  // Item Messages
  ListLiveItemRequest(
    result: Result(List(#(String, String, String, String)), rsvp.Error(String)),
  )
  ListSavedItemRequest(
    result: Result(List(rss_item.RssItem), rsvp.Error(String)),
  )
  SaveItemRequest(result: Result(response.Response(String), rsvp.Error(String)))
}

pub fn error_dispatch(dispatch) {
  dispatch(GoToPage(Error))
}

pub fn simple_page_dispatcher(page: Page) {
  fn(dispatch) { dispatch(GoToPage(page)) }
}
