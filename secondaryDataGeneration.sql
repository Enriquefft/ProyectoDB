DO $$

DECLARE
  rowCount CONSTANT INTEGER := 1000000;
  --rowCount CONSTANT INTEGER := 10000;
  --rowCount CONSTANT INTEGER := 100000;
  --rowCount CONSTANT INTEGER := 1000000;
  localDetailsCount CONSTANT INTEGER := 1000000;
  DeliveryDetailsCount CONSTANT INTEGER := 500000;
    customerDetailsInDetails CONSTANT INTEGER := 600;
    customersInDetails CONSTANT INTEGER := 1000;

  vehiclesCount CONSTANT INTEGER := 20;

  customerCompaniesCount CONSTANT INTEGER := 1000;


BEGIN

-- Module for sampling X random rows (similar to: TABLESAMPLE SYSTEM)
CREATE EXTENSION tsm_system_rows;

set search_path to public, proyecto_1m;
--set search_path to proyecto_10k;
--set search_path to proyecto_100k;
--set search_path to proyecto_1m;

-- local_details
INSERT INTO local_details(
  customer_id, dni
)
SELECT id, dni
FROM
  customer_details TABLESAMPLE SYSTEM_ROWS (customerDetailsInDetails) 
CROSS JOIN
  local_customers TABLESAMPLE SYSTEM_ROWS (customersInDetails)
order by random() limit localDetailsCount / 2;

INSERT INTO local_details(
  customer_id, dni
)
SELECT id, dni
 FROM 
   (SELECT dni, row_number() over () AS rowc from customer_details TABLESAMPLE SYSTEM_ROWS(localDetailsCount / 2)) AS numbered_dnis
 JOIN 
   local_customers on local_customers.id = numbered_dnis.rowc limit localDetailsCount / 2;


-- delivery_details
INSERT INTO delivery_details(
  customer_id, dni
)
SELECT id, dni
FROM
  customer_details TABLESAMPLE SYSTEM_ROWS (customerDetailsInDetails / 2) 
CROSS JOIN
  delivery_customers TABLESAMPLE SYSTEM_ROWS (CustomersInDetails / 2)
order by random() limit DeliveryDetailsCount / 2;

INSERT INTO delivery_details(
  customer_id, dni
)
SELECT id, dni
 FROM 
   (SELECT dni, row_number() over () AS rowc from customer_details TABLESAMPLE SYSTEM_ROWS(DeliveryDetailsCount / 2)) AS numbered_dnis
 JOIN 
   delivery_customers on delivery_customers.id = numbered_dnis.rowc limit DeliveryDetailsCount / 2;



-- local_sells
INSERT INTO local_sells(
 customer_id, address, date_time, payment_method
)
SELECT
  id AS customer_id,
  address as address,
    timestamp '2020-1-29 20:00:00' + random() * ( timestamp '2025-12-29 20:00:00' - timestamp '2020-1-29 20:00:00') as date_time,
  (array['efectivo', 'tarjeta', 'yape', 'plin', 'transferencia'])[floor(random() * 5 + 1)] as payment_method
FROM 
  (select id, floor(random() * 25+ 1) as randomShop from local_customers) as customers
JOIN
  (select address, row_number() over () as rowC from local_shops) as locals
ON locals.rowC = customers.randomShop;



-- Insert every local sell once
INSERT INTO local_sell_unit(
  sell_id, product_code, amount, subtotal
)
SELECT
   id AS sell_id,
   code AS product_code,
   amount AS amount,
   amount * price AS subtotal
 FROM ( SELECT
   id,
   floor(random() * 43 + 1) as randomProd,
   (random() * (50 - 1) + 1)::INTEGER AS amount FROM local_sells) AS sells JOIN 
 products ON products.code = sells.randomProd;

INSERT INTO local_sell_unit(
  sell_id, product_code, amount, subtotal
)
SELECT
   id AS sell_id,
   code AS product_code,
   amount AS amount,
   amount * price AS subtotal
 FROM ( SELECT
   id,
   (random() * (50 - 1) + 1)::INTEGER AS amount
  FROM local_sells TABLESAMPLE SYSTEM_ROWS(120000) ) AS sells
CROSS JOIN (select code, price from products) as products;
  
 

-- delivery_sells
INSERT INTO delivery_sells(
  customer_id, address, date_time, delivery_price, payment_method
)
SELECT
   id AS customer_id,
   address as address,
     timestamp '2020-1-29 20:00:00' + random() * ( timestamp '2025-12-29 20:00:00' - timestamp '2020-1-29 20:00:00') as date_time,
  (random() * (20 - 5) + 5)::INTEGER::MONEY as delivery_price, -- Compute
   (array['efectivo', 'tarjeta', 'yape', 'plin', 'transferencia'])[floor(random() * 5 + 1)] as payment_method
 FROM (
   (select id, floor(random() * 25+ 1) as randomShop from delivery_customers) as customers
 JOIN
   (select address, row_number() over () as rowC from local_shops) as locals
 ON locals.rowC = customers.randomShop ) data;



INSERT INTO delivery_sell_unit(
  sell_id, product_code, amount, subtotal
)
SELECT
   id AS sell_id,
   code AS product_code,
   amount AS amount,
   amount * price AS subtotal
 FROM ( SELECT
   id,
   floor(random() * 43 + 1) as randomProd,
   (random() * (50 - 1) + 1)::INTEGER AS amount FROM delivery_sells) AS sells JOIN 
 products ON products.code = sells.randomProd;

INSERT INTO delivery_sell_unit(
  sell_id, product_code, amount, subtotal
)
SELECT
   id AS sell_id,
   code AS product_code,
   amount AS amount,
   amount * price AS subtotal
 FROM ( SELECT
   id,
   (random() * (50 - 1) + 1)::INTEGER AS amount
  FROM delivery_sells TABLESAMPLE SYSTEM_ROWS(120000) ) AS sells
CROSS JOIN (select code, price from products) as products;


-- vehicles
INSERT INTO vehicles (
  plate, shop_address, delivery_count
)
SELECT
  left(md5(random()::text), 6) AS plate,
  address,
  (random() * (1000 - 0) + 0)::INTEGER AS delivery_count
FROM local_shops TABLESAMPLE SYSTEM_ROWS(vehiclesCount);




INSERT INTO provider_companies(
  ruc, address, phone_number, provides_count
)
select
  ruc,
  (array['lima', 'chorrillos', 'calleo', 'miraflores', 'barranco', 'surquillo'])[floor(random() * 6 + 1)] || ' ' || left(md5(random()::text), 3) as address,
  (random() * (999999999 - 100000000) + 100000000)::INTEGER::TEXT as phone_number,
  random() * (100 - 1) + 1 as provides_count
FROM unnest(array['brandless', 'vildoso', 'socosani', 'ism', 'amauta', 'majes', 'aruba', 'quillabamba', 'roma', 'dimas', 'iray']) as arrname
join companies_info on companies_info.name = arrname.arrname;



-- customer_companies
--INSERT INTO customer_companies(
  --ruc, address, phone_number
--)
--Select
  --ruc,
  --(array['lima', 'chorrillos', 'calleo', 'miraflores', 'barranco', 'surquillo'])[floor(random() * 6 + 1)] || ' ' || left(md5(random()::text), 3) as address,
  --(random() * (999999999 - 100000000) + 100000000)::INTEGER::TEXT as phone_number
--FROM companies_info TABLESAMPLE SYSTEM_ROWS(customerCompaniesCount);
--
--
---- products_in_local
---- local_address, product_code, expiration_date, exhibition_type, stock
--INSERT INTO products_in_local(
  --local_address, product_code, expiration_date, exhibition_type, stock
--)
--SELECT
  --address,
  --code as product_code,
  --timestamp '2020-12-29 20:00:00' + random() * ( timestamp '2025-12-29 20:00:00' - timestamp '2020-12-29 20:00:00') as expiration_date,
  --(array['no exhibido', 'refrigerado', 'congelado', 'normal'])[floor(random() * 3 + 1)] as exhibition_type,
  --random() * (100 - 1) + 1 as stock
--FROM local_shops CROSS JOIN products TABLESAMPLE SYSTEM_ROWS (800);
--

END $$



