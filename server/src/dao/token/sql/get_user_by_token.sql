SELECT user_id
FROM auth_token
WHERE
  token = $1
  AND expires_at > NOW()
