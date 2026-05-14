SELECT
  id, username, email, password
FROM
  users
where
  username=$1
