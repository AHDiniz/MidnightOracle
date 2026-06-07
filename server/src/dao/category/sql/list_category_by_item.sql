SELECT
  category.id, category.name
FROM
  category
INNER JOIN
  item_category
  ON item_category.category_id = category.id
WHERE
  item_category.item_id = $1
