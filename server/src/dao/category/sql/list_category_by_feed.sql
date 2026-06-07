SELECT
  category.id, category.name
FROM
  category
INNER JOIN
  feed_category
  ON feed_category.category_id = category.id
WHERE
  feed_category.feed_id = $1
