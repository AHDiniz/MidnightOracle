
classDiagram

namespace Domain{

class User{
<< id >> Long : _id  #123; generation=auto #125;
 String : email  #123; notnull #125;
 String : username  #123; notnull #125;
 String : password  #123; notnull #125;
}
class RSSFeed{
<< id >> Long : _id  #123; generation=auto #125;
 String : url  #123; notnull #125;
 String : title  #123; notnull #125;
 String : description  #123; notnull #125;
 Timestamp : pub_date  #123; precision=datetime #125;
 Timestamp : last_build_date  #123; precision=datetime #125;
 String : image_url 
}
class RSSItem{
<< id >> Long : _id  #123; generation=auto #125;
 String : title 
 String : link 
 String : description 
 String : enclosure_url 
}
class Category{
<< id >> Long : _id  #123; generation=auto #125;
 String : name  #123; notnull #125;
}
}
RSSFeed "*" <-- "1" User 
Category "*" <-- "*" RSSFeed 
RSSItem "*" <-- "1" RSSFeed 
Category "*" <-- "*" RSSItem 
namespace Control{

class RegistrationController{
 User : user 
String : register ()
}
}
Success  <..  RegistrationController 
RegistrationService  <--  RegistrationController 
namespace Navigation{

class Index{
}
class RegForm{
 inputText : user__name 
 inputText : user__email 
 inputSecret : user__password 
 commandButton : register 
}
class Success{
 outputText : user__name 
}
}
RegForm  *--  Index 
RegistrationController  <..  RegForm 
namespace Application{

class RegistrationService{
String : register ()
}
class LoginService{
User : login ()
}
class SearchService{
List : search ()
}
}
UserDAO  <..  LoginService 
namespace Persistence{

class UserDAO{
User : get (username, password)
User : create (email, username, password)
}
class RSSFeedDAO{
RSSFeed : create (url, title, description, pub_date, last_build_date, image_url)
RSSFeed : update (_id, url, title, description, pub_date, last_build_date, image_url)
List : list_by_user (user)
nil : delete (_id)
}
class RSSItemDAO{
RSSItem : create (title, link, description, enclosure_url)
RSSItem : update (_id, title, link, description, enclosure_url)
List : list_by_feed (rss_feed)
nil : delete (_id)
}
class CategoryDAO{
Category : create (name)
List : list_by_user (user)
List : list_by_feed (rss_feed)
List : list_by_item (rss_item)
nil : delete (_id)
}
}

<< persistent >> User

<< persistent >> RSSFeed

<< persistent >> RSSItem

<< persistent >> Category

<< page >> Index

<< form >> RegForm

<< page >> Success
