DO $$

DECLARE
  --rowCount CONSTANT INTEGER := 1000;
  --rowCount CONSTANT INTEGER := 10000;
  --rowCount CONSTANT INTEGER := 100000;
  rowCount CONSTANT INTEGER := 1000000;

BEGIN

--set search_path to proyecto_1k;
--set search_path to proyecto_10k;
--set search_path to proyecto_100k;
set search_path to proyecto_1m;


-- customer_details
INSERT INTO customer_details(
  dni, name, visit_count
)
SELECT DISTINCT * FROM(
SELECT
  (random() * (99999999 - 10000000) + 10000000)::INTEGER as dni, -- 8 digits
  (array['Juan', 'Luis', 'Marco', 'Pedro', 'Diego', 'sebastian', 'Jaime', 'Marta', 'Lourdes', 'Ambrosio', 'Alejandro', 'Jhon', 'Elizabeth', 'Camila',
    left(md5(random()::text), 8), left(md5(random()::text), 8)]
  )[floor(random() * 5 + 1)] as name,
  (random() * (100 - 1) + 1)::INTEGER as visit_count
FROM generate_series(1, rowCount * 1.2) AS idx ORDER BY random()
) as data LIMIT rowCount;


-- customers
INSERT INTO local_customers(
  tmp_col
)
SELECT * FROM(
SELECT
1
FROM generate_series(1, rowCount) AS idx
) as data LIMIT rowCount;


-- delivery_customers
INSERT INTO delivery_customers(
  address, phone_number
)
SELECT * FROM(
SELECT
  (array['lima', 'chorrillos', 'miraflores', 'chacarilla', 'la molina', 'barranco', 'surco', 'san borja'])[floor(random() * 8 + 1)] || ' ' || left(md5(random()::text), 10) as address,
  (random() * (999999999 - 100000000) + 100000000)::INTEGER::TEXT as phone_number
FROM generate_series(1, rowCount) AS idx
) as data LIMIT rowCount;


---- local_shops
INSERT INTO local_shops(
  address, phone_number, local_size
)
SELECT DISTINCT ON (phone_number)
  (array['lima', 'chorrillos', 'miraflores', 'chacarilla', 'la molina', 'barranco', 'surco', 'san borja'])[floor(random() * 8 + 1)] || ' ' || left(md5(random()::text), 10) AS address,
  (random() * (999999999 - 900000000) + 900000000)::INTEGER::TEXT as phone_number,
  (array['small', 'medium', 'big'])[floor(random() * 3 + 1)] AS local_size
FROM generate_series(1, 25) AS idx;
  

-- companies_info
INSERT INTO companies_info(
  ruc, email, name
)
SELECT DISTINCT ON (ruc)
  (random() * (99999999999 - 10000000000) + 10000000000)::NUMERIC(11, 0) as ruc,
  left(md5(idx::text), 25) as email,
  (array['brandless', 'vildoso', 'socosani', 'ism', 'amauta', 'majes', 'aruba', 'quillabamba', 'roma', 'dimas', 'iray'
  , left(md5(random()::text), 8) , left(md5(random()::text), 8) , left(md5(random()::text), 8)
    ])[floor(random() * 11 + 1)] AS name
FROM generate_series(1, rowCount * 1.2) AS idx LIMIT rowCount;



-- promotions
INSERTO INTO promotions (
  validity
  value
)
SELECT
  random() > 0.2 as validity,
  (random() * (20 - 1) + 20)::INTEGER::MONEY
FROM
  generate_series(1, 100) AS id;


-- product_lists
INSERT INTO product_lists(
  date, validity
)
SELECT
  timestamp '2020-12-29 20:00:00' +
  random() * ( timestamp '2025-12-29 20:00:00' -
  timestamp '2020-12-29 20:00:00') as date,
  FALSE as validity
FROM generate_series(1, 30) AS idx;


-- employees
INSERT INTO employees(
  dni, name, address, phone_number, salary
)
select DISTINCT ON (phone_number)
* FROM (
SELECT DISTINCT ON (dni)
  (random() * (99999999 - 10000000) + 10000000)::NUMERIC(8, 0) as dni,
  (array['sklave_uJ', 'sklave_uL', 'sklave_aM', 'sklave_eP', 'sklave_iD', 'sklave_es', 'sklave_aJ', 'sklave_aM', 'sklave_oL', 'sklave_mA', 'sklave_lA', 'sklave_hJ', 'sklave_lE', 'sklave_aC',
    left(md5(random()::text), 8), left(md5(random()::text), 8)]
  )[floor(random() * 5 + 1)] as name,
  (array['local1', 'chorrillos', 'miraflores', 'chacarilla', 'la molina', 'local2', 'local3', 'san borja'])[floor(random() * 8 + 1)] || ' ' || left(md5(random()::text), 10) as address,
  (random() * (999999999 - 100000000) + 100000000)::INTEGER::TEXT as phone_number,
  (random() * (10000 - 800) + 800)::NUMERIC::MONEY as salary
FROM generate_series(1, rowCount*1.2) AS idx) AS data LIMIT rowCount;

  
-- products
--INSERT INTO products(
  --price, category, brand, description
--)
--SELECT * FROM(
--SELECT
  --(random() * (999 - 1) + 1)::NUMERIC::MONEY as price,
  --(array['uncategorized', 'food', 'drink'])[floor(random() * 3 + 1)] as category,
  --(array['brandless', 'vildoso', 'socosani', 'ism', 'amauta', 'majes', 'aruba', 'quillabamba', 'roma', 'dimas', 'iray'])[floor(random() * 11 + 1)] AS brand,
  --left(md5(idx::text), 10) as description
--FROM generate_series(1, rowCount) AS idx
--) as data;

--\copy products(price, category, brand, description) from '/home/enrique/Documents/ProyectoDB/products.csv' DELIMITER ',' CSV HEADER;

END $$
