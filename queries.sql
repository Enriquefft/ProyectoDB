
set search_path to proyecto_1m, public;

select max(count), ruc
from (
select delivery_ruc_count.ruc, sum_del + sum_local as count
FROM

(SELECT ruc, count(ruc) AS sum_del FROM 

  (SELECT id AS delivery_id
FROM delivery_sells WHERE
  EXTRACT(YEAR FROM date_time) = EXTRACT(YEAR FROM CURRENT_DATE)) AS delivery_sells
JOIN
  company_delivery_sells
ON
company_delivery_sells.sell_id = delivery_sells.delivery_id GROUP BY ruc) AS delivery_ruc_count

FULL OUTER JOIN

(SELECT ruc, count(ruc) AS sum_local FROM 
  (SELECT id AS local_id
FROM local_sells WHERE
  EXTRACT(YEAR FROM date_time) = EXTRACT(YEAR FROM CURRENT_DATE)) AS local_sells
JOIN
  company_local_sells
ON
company_local_sells.sell_id = local_sells.local_id GROUP BY ruc) AS local_ruc_count

ON delivery_ruc_count.ruc = local_ruc_count.ruc) data group by ruc;

