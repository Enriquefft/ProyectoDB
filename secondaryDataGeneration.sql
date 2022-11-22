DO $$

DECLARE
  rowCount CONSTANT INTEGER := 1000000;
  --rowCount CONSTANT INTEGER := 10000;
  --rowCount CONSTANT INTEGER := 100000;
  --rowCount CONSTANT INTEGER := 1000000;

BEGIN

set search_path to proyecto_1m;
set search_path to proyecto_10k;
set search_path to proyecto_100k;
set search_path to proyecto_1m;

 local_details
INSERT INTO local_details(
  customer_id, dni
)
select id, dni
from 
  (select dni, row_number() over () as rowc from
    ( SELECT dni from customer_details ORDER BY random() limit rowCount ) AS random_dnis
  ) AS numbered_dnis
JOIN 
  local_customers on local_customers.id = numbered_dnis.rowc limit rowCount;


-- delivery_details
INSERT INTO delivery_details(
  customer_id, dni
)
SELECT
  id as customer_id,
  dni
from (
  (select dni, row_number() over () as rowc from
    ( SELECT dni from customer_details ORDER BY random() limit rowCount ) AS random_dnis
  ) AS numbered_dnis
JOIN 
  delivery_customers on delivery_customers.id = numbered_dnis.rowc) AS data limit rowCount ;


-- local_sells
INSERT INTO local_sells(
  customer_id, address, date_time, products_price, payment_method
)
SELECT * FROM (
SELECT DISTINCT ON (customer_id, address)
  id as customer_id,
  address as address,
  timestamp '2020-12-29 20:00:00' + random() * ( timestamp '2025-12-29 20:00:00' - timestamp '2020-12-29 20:00:00') as date_time,
  (random() * (1000 - 10) + 10)::INTEGER::MONEY as products_price,
  left(md5(random()::text), 10) as payment_method
 
   from (select id, row_number() over () as rowc_customer from local_customers order by random() limit SQRT(rowCount*1.2) ) AS customers
   cross JOIN (select address, row_number() over () as rowc_local from local_shops order by random() limit SQRT(rowCount*1.2) ) AS locals
 ) AS data ORDER BY random() limit rowCount;
 

 local_sell_unit
INSERT INTO local_sell_unit(
  sell_id, product_code, amount, subtotal
)
select * from (
select DISTINCT ON (code, sell_id)
id AS sell_id,
code AS product_code,
(random() * (100 - 1) + 1)::INTEGER AS amount,
amount * price as subtotal
from (
  (select id from local_sells order by random() limit (sqrt(rowCount) * 5)) AS local_sells CROSS JOIN
  (select code, price from products order by random() limit (sqrt(rowCount) * 5)) AS prods) AS data) AS randomized
  order by random() limit rowCount;

-- delivary_sells
INSERT INTO delivery_sells(
  customer_id, address, date_time, delivery_price, payment_method
)
SELECT * FROM (
SELECT DISTINCT ON (customer_id, address)
  id as customer_id,
  address as address,
  timestamp '2020-12-29 20:00:00' + random() * ( timestamp '2025-12-29 20:00:00' - timestamp '2020-12-29 20:00:00') as date_time,
  (random() * (20 - 5) + 5)::INTEGER::MONEY as delivery_price, -- Compute
  (array['efectivo', 'tarjeta', 'yape', 'plin', 'transferencia'])[floor(random() * 5 + 1)] as payment_method
 
   from (select id from delivery_customers order by random() limit SQRT(rowCount*1.5) ) AS customers
   cross JOIN (
   select address from local_shops order by random() limit SQRT(rowCount) ) AS locals )
   AS data ORDER BY random() limit rowCount;
 

-- local_sell_unit
INSERT INTO delivery_sell_unit(
  sell_id, product_code, amount, subtotal
)
SELECT 
id AS sell_id,
code AS product_code,
(random() * (100 - 1) + 1)::INTEGER AS amount,
price * amount as subtotal
from (
  (select id from delivery_sells order by random() limit (sqrt(rowCount) * 6)) AS delivery_sells 
  CROSS JOIN (
  select code, price from products order by random() limit (sqrt(rowCount) * 4)) AS prods )
  AS data ORDER BY random() LIMIT rowCount;

-- vehicles









-- provider_companies
INSERT INTO provider_companies(
  ruc, address, phone_number, provides_count
)



-- customer_companies

-- products_in_local

END $$



