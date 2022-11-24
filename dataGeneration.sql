DO $$

DECLARE
  --rowCount CONSTANT INTEGER := 1000;
  --rowCount CONSTANT INTEGER := 10000;
  --rowCount CONSTANT INTEGER := 100000;
  rowCount CONSTANT INTEGER := 1000000;

  customerDetailsCount CONSTANT INTEGER := 10000; -- 10 k
  localSellsCount CONSTANT INTEGER := 4000000;-- 4M
  deliverySellsCount CONSTANT INTEGER := 1000000; -- 4M

  companyLocalSellCount CONSTANT INTEGER := 100000; -- 100k
  companydeliverySellCount CONSTANT INTEGER := 100000; -- 100k

  companiesInfoCount CONSTANT INTEGER := 1000;

  promotionsCount CONSTANT INTEGER := 100;

  product_listsCount CONSTANT INTEGER := 30;

  employeeCount CONSTANT INTEGER := 70;

BEGIN


--set search_path to proyecto_1k;
--set search_path to proyecto_10k;
--set search_path to proyecto_100k;
set search_path to proyecto_1m;


-- customer_details
INSERT INTO customer_details(
  dni, name, visit_count
)
SELECT DISTINCT ON (dni) * FROM(
SELECT
  (random() * (99999999 - 10000000) + 10000000)::INTEGER as dni, -- 8 digits
  (array['Juan', 'Luis', 'Marco', 'Pedro', 'Diego', 'sebastian', 'Jaime', 'Marta', 'Lourdes', 'Ambrosio', 'Alejandro', 'Jhon', 'Elizabeth', 'Camila']
  )[floor(random() * 5 + 1)] || ' ' || left(md5(random()::text), 5) as name,
  (random() * (100 - 1) + 1)::INTEGER as visit_count
FROM generate_series(1, customerDetailsCount * 1.5) AS idx ORDER BY random()
) as data LIMIT customerDetailsCount;



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
  --(array['brandless', 'vildoso', 'socosani', 'ism', 'amauta', 'majes', 'aruba', 'quillabamba', 'roma', 'dimas', 'iray'])[floor(random() * 11 + 1)] AS name
  (array['brandless', 'vildoso', 'socosani', 'ism', 'amauta', 'majes', 'aruba', 'quillabamba', 'roma', 'dimas', 'iray'])[floor(random() * 11 + 1)] || ' ' || left(md5(random()::text), 5) AS name
FROM generate_series(1, companiesInfoCount) AS idx LIMIT rowCount;


-- customer companies info
INSERT INTO companies_info(
  ruc, email, name
)
select
  (random() * (99999999999 - 10000000000) + 10000000000)::NUMERIC(11, 0) as ruc,
  left(md5(random()::text), 25) as email,
  name
  from unnest(array['brandless', 'vildoso', 'socosani', 'ism', 'amauta', 'majes', 'aruba', 'quillabamba', 'roma', 'dimas', 'iray']) as name;

-- promotions
INSERT INTO promotions (
  validity,
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
SELECT
  (random() * (99999999 - 10000000) + 10000000)::NUMERIC(8, 0) as dni,
  (array['sklave_uJ', 'sklave_uL', 'sklave_aM', 'sklave_eP', 'sklave_iD', 'sklave_es', 'sklave_aJ', 'sklave_aM', 'sklave_oL', 'sklave_mA', 'sklave_lA', 'sklave_hJ', 'sklave_lE', 'sklave_aC']
  )[floor(random() * 5 + 1)] || ' ' || left(md5(random()::text), 5) as name,
  (array['local1', 'chorrillos', 'miraflores', 'chacarilla', 'la molina', 'local2', 'local3', 'san borja'])[floor(random() * 8 + 1)] || ' ' || left(md5(random()::text), 10) as address,
  (random() * (999999999 - 100000000) + 100000000)::INTEGER::TEXT as phone_number,
  (random() * (10000 - 800) + 800)::NUMERIC::MONEY as salary
FROM generate_series(1, employeeCount);

  
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

--\copy proyecto_1m.products(price, category, brand, description) from '/home/enrique/Documents/ProyectoDB/products.csv' DELIMITER ',' CSV HEADER;

END $$
