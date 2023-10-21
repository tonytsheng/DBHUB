CREATE SCHEMA inventory;
CREATE TABLE inventory.products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT CURRENT_TIMESTAMP,
  site_id text NOT NULL
)
;

INSERT INTO inventory.products (product_name, site_id)
VALUES ('soap', 'pg5001'), ('shampoo', 'pg5001'), ('conditioner', 'pg5001')
;
