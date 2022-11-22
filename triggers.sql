SET search_path='proyecto_1m';

CREATE OR REPLACE FUNCTION update_local_sells() RETURNS TRIGGER AS $$

BEGIN

UPDATE local_sells
SET products_price = ( products_price + NEW.subtotal)
WHERE local_sells.id = NEW.sell_id;

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE  TRIGGER update_local_sells_trigger
AFTER INSERT  ON local_sell_unit
FOR EACH ROW EXECUTE PROCEDURE update_local_sells();


CREATE OR REPLACE FUNCTION update_delivery_sells() RETURNS TRIGGER AS $$

BEGIN

UPDATE delivery_sells
SET products_price = (products_price + NEW.subtotal)
WHERE delivery_sells.id = NEW.sell_id;

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE  TRIGGER update_delivery_sells_trigger
AFTER INSERT  ON delivery_sell_unit
FOR EACH ROW EXECUTE PROCEDURE update_delivery_sells();
