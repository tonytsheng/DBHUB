CREATE SCHEMA inventory;
CREATE TABLE inventory.products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

INSERT INTO inventory.products (product_name)
VALUES ('soap'), ('shampoo'), ('conditioner')
;

CREATE EXTENSION IF NOT EXISTS pgactive;

