

DO $$

DECLARE
  rowCount CONSTANT INTEGER := 1000;

BEGIN

set search_path to proyecto_1k;

-- customer_details
INSERT INTO customer_details(
  dni, name, visit_count
)
SELECT * FROM(
SELECT
  (random() * (99999999 - 10000000) + 10000000)::INTEGER as dni,
  (array['juan', 'lues', 'pedro', 'jaime', left(md5(random()::text), 8)])[floor(random() * 5 + 1)] as name,
  (random() * (100 - 1) + 1)::INTEGER as visit_count
FROM generate_series(1, rowCount) AS idx
) as data;

-- customers
INSERT INTO customers(
  temp_col
)
SELECT * FROM(
SELECT
1
FROM generate_series(1, rowCount) AS idx
) as data;

-- delivery_customers
INSERT INTO delivery_customers(
  address, phone_number
)
SELECT * FROM(
SELECT
  left(md5(idx::text), 20) as address,
  (random() * (999999999 - 100000000) + 100000000)::INTEGER::TEXT
FROM generate_series(1, rowCount) AS idx
) as data;


-- local_shops
INSERT INTO local_shops(
  address, phone_number, local_size
)
SELECT * FROM(
SELECT
  left(md5(idx::text), 20) as address,
  (random() * (999999999 - 100000000) + 100000000)::INTEGER::TEXT as phone_number,
  (array['small', 'medium', 'big'])[floor(random() * 3 + 1)]
FROM generate_series(1, rowCount) AS idx
) as data;
  

-- companies_info
INSERT INTO companies_info(
  ruc, email, name
)
SELECT * FROM(
SELECT
  (random() * (99999999999 - 10000000000) + 10000000000)::NUMERIC(11, 0) as ruc,
  left(md5(idx::text), 25) as email,
  left(md5(idx::text), 25) as name
FROM generate_series(1, rowCount) AS idx
) as data;

-- promotions
INSERT INTO promotions(
  validity, value
)
SELECT * FROM(
SELECT
  random() > 0.5 as validity,
  (random() * (999 - 10) + 10)::NUMERIC::MONEY as value
FROM generate_series(1, rowCount) AS idx
) as data;


-- product_lists
INSERT INTO product_lists(
  date, validity
)
SELECT * FROM(
SELECT
  timestamp '2020-12-29 20:00:00' +
  random() * ( timestamp '2025-12-29 20:00:00' -
  timestamp '2020-12-29 20:00:00') as date,
  FALSE as validity
FROM generate_series(1, rowCount) AS idx
) as data;

-- employees
INSERT INTO employees(
  dni, name, address, phone_number, salary
)
SELECT * FROM(
SELECT
  (random() * (99999999 - 10000000) + 10000000)::NUMERIC(8, 0) as dni,
  left(md5(idx::text), 10) as name,
  left(md5(idx::text), 25) as address,
  (random() * (999999999 - 100000000) + 100000000)::INTEGER::TEXT as phone_number,
  (random() * (999999 - 10000) + 10000)::NUMERIC::MONEY as salary
FROM generate_series(1, rowCount) AS idx
) as data;

  
-- products
INSERT INTO products(
  price, category, brand, description
)
SELECT * FROM(
SELECT
  (random() * (999 - 1) + 1)::NUMERIC::MONEY as price,
  (array['uncategorized', 'food', 'drink'])[floor(random() * 3 + 1)] as category,
  (array['brandless', 'brand1', 'brand2'])[floor(random() * 3 + 1)] as brand,
  left(md5(idx::text), 10) as description
FROM generate_series(1, rowCount) AS idx
) as data;


END $$

