SELECT token
FROM auth_token
WHERE
  user_id = $1
  AND expires_at > NOW()
