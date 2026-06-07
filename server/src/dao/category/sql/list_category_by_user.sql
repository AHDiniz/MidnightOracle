SELECT
  id, name
FROM
  category
WHERE
  user_id = $1
