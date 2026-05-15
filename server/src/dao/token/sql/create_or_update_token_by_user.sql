INSERT INTO auth_token (user_id, token)
VALUES ($1, $2)
ON CONFLICT (user_id) DO UPDATE
  SET
    token = $2,
    expires_at = DEFAULT
