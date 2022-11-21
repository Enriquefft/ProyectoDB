DO $$

DECLARE
  rowCount CONSTANT INTEGER := 1000;
  --rowCount CONSTANT INTEGER := 10000;
  --rowCount CONSTANT INTEGER := 100000;
  --rowCount CONSTANT INTEGER := 1000000;

BEGIN

set search_path to proyecto_1k;
--set search_path to proyecto_10k;
--set search_path to proyecto_100k;
--set search_path to proyecto_1m;

-- local_details
--INSERT INTO local_details(
--  customer_id, dni
--)
--SELECT * FROM (
--select id, dni
--from (select dni, row_number() over () as rowc from customer_details order by random()) details
--JOIN customers on customers.id = details.rowc limit rowCount
--) as data;



-- delivery_details

--INSERT INTO delivery_details(
  --customer_id, dni
--)
--SELECT * FROM (
--select distinct id, dni
--from (select dni, row_number() over () as rowc from customer_details order by random()) details
--JOIN customers on customers.id = details.rowc limit rowCount
--) as data;

-- local_sells

--INSERT INTO local_sells(
  --customer_id, address, date_time, products_price, payment_method
--)
--SELECT * FROM (
--SELECT
  --id as customer_id,
  --address as address,
  --timestamp '2020-12-29 20:00:00' + random() * ( timestamp '2025-12-29 20:00:00' - timestamp '2025-12-29 20:00:00') as date_time,
  --(random() * (1000 - 10) + 10)::INTEGER::MONEY as products_price,
  --left(md5(random()::text), 10) as payment_method
 --
 --from (select id, row_number() over () as rowc_customer from customers order by random()) customers
 --cross JOIN (select address, row_number() over () as rowc_local from local_shops order by random()) locals order by random() limit rowCount
--
--) AS data;

-- local_sell_unit
INSERT INTO local_sell_unit(
  local_sell_id, product_code, amount, subtotal
)
SELECT * FROM (
select
  local_sells.id as local_sell_id,

from (
  select 
  (select id, row_number() over () as rowc_sell from local_sells order by random()) local_sells,
  JOIN (select product_code, row_number() over () 
    as rowc_product from products order by random()) products) ON local_sells.rowc_sell = products.rowc_product
  order by random() limit rowCount
) as data;


select
*
from (
  (select id, row_number() over () as rowc_sell from local_sells order by random()) local_sells JOIN
  (select product_code, row_number() over () as rowc_product from products order by random()) products
  ON local_sells.rowc_sell = products.rowc_product order by random())
limit rowCount;




-- vehicles

-- provider_companies

-- customer_companies

-- products_in_local

END $$
