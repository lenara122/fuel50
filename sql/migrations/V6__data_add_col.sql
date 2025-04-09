-- insert one user 
WITH max_id AS (
  SELECT MAX(id) + 1 AS next_id FROM users
)
INSERT INTO users (username, name, address)
SELECT
  'username_' || next_id,
  'name_' || next_id,
  'address_' || next_id
FROM max_id;
