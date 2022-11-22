SELECT dni, name, sum_local + sum_delivery AS suma
FROM (
    SELECT customer_details.dni, name, SUM(local_sells.products_price) AS sum_local 
    FROM local_sells JOIN local_customers 
    ON local_sells.customer_id=local_customers.id 
    JOIN local_details 
    ON local_details.customer_id=local_customers.id 
    JOIN customer_details 
    ON customer_details.dni=local_details.dni
    WHERE EXTRACT(YEAR FROM delivery_sells.date_time)=EXTRACT(YEAR FROM CURRENT_DATE)
    ) AS loc 
    JOIN 
    (
    SELECT dni, name, SUM(delivery_sells.products_price) AS sum_delivery 
    FROM delivery_sells JOIN delivery_customers 
    ON delivery_sells.customer_id=delivery_customers.id
    JOIN delivery_details 
    ON delivery_details.customer_id=delivery_customers.id
    JOIN customer_details 
    ON customer_details.dni=delivery_details.dni
    WHERE EXTRACT(YEAR FROM delivery_sells.date_time)=EXTRACT(YEAR FROM CURRENT_DATE)
    ) AS del 
    ON loc.dni = del.dni
    GROUP BY loc.dni
    ORDER BY sum_local DESC LIMIT 1;

