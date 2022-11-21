BEGIN TRANSACTION;

CREATE SCHEMA IF NOT EXISTS proyecto_1k;
CREATE SCHEMA IF NOT EXISTS proyecto_10k;
CREATE SCHEMA IF NOT EXISTS proyecto_100k;
CREATE SCHEMA IF NOT EXISTS proyecto_1m;

--set search_path to proyecto_1k;
--set search_path to proyecto_10k;
--set search_path to proyecto_100k;
set search_path to proyecto_1m;

CREATE TABLE IF NOT EXISTS customer_details(
  PRIMARY KEY(dni),
  dni         NUMERIC(8, 0)   NOT NULL,
  name        VARCHAR(50)     NOT NULL,
  visit_count NUMERIC(4, 0)   NOT NULL
);

CREATE TABLE IF NOT EXISTS customers (
  PRIMARY KEY(id),
  id SERIAL
);

CREATE TABLE IF NOT EXISTS has_details (
  PRIMARY KEY (customer_id, dni),
  customer_id INTEGER       NOT NULL,
              CONSTRAINT fk_customer_id FOREIGN KEY (customer_id) REFERENCES customers (id),
  dni         NUMERIC(8, 0) NOT NULL,
              CONSTRAINT fk_customer_dni FOREIGN KEY (dni) REFERENCES customer_details (dni)
);

CREATE TABLE IF NOT EXISTS delivery_customers(
  PRIMARY KEY (id),
  id SERIAL,
  address       VARCHAR (50)  NOT NULL,
  phone_number VARCHAR (12)  NOT NULL
);

CREATE TABLE IF NOT EXISTS local_shops(
  PRIMARY KEY(address),
  address      VARCHAR(50)    NOT NULL,
  phone_number VARCHAR(12)    NOT NULL,
  local_size   VARCHAR(10)    NOT NULL
);

CREATE TABLE IF NOT EXISTS vehicles(
  PRIMARY KEY(plate),
  plate          VARCHAR(6)    NOT NULL,
  shop_address   VARCHAR(50)   NOT NULL,
                 CONSTRAINT fk_vehicle_shop_address FOREIGN KEY(shop_address) REFERENCES local_shops(address),
  delivery_count NUMERIC(4, 0) NOT NULL
);

CREATE TABLE IF NOT EXISTS companies_info (
  PRIMARY KEY(ruc),
  ruc            NUMERIC(11, 0) NOT NULL,
  email          VARCHAR(50)    NOT NULL,
  name           VARCHAR(50)    NOT NULL
);

CREATE TABLE IF NOT EXISTS provider_companies (
  PRIMARY KEY(ruc, address),
  ruc            NUMERIC(11, 0) NOT NULL,
                 CONSTRAINT fk_ruc FOREIGN KEY (ruc) REFERENCES companies_info (ruc),
  address        VARCHAR(50)    NOT NULL,
  phone_number   VARCHAR(12)    NOT NULL,
  provides_count INTEGER        NOT NULL
);

CREATE TABLE IF NOT EXISTS customer_companies (
  PRIMARY KEY(ruc, address),
  ruc            NUMERIC(11, 0) NOT NULL,
                 CONSTRAINT fk_ruc FOREIGN KEY (ruc) REFERENCES companies_info (ruc),
  address        VARCHAR(50)    NOT NULL,
  phone_number   VARCHAR(12)    NOT NULL
);

CREATE TABLE IF NOT EXISTS products (
  PRIMARY KEY(code),
  code        SERIAL,
  price       MONEY       NOT NULL,
              CONSTRAINT products_positive_price CHECK (price > 0::MONEY),
  category    VARCHAR(15) NOT NULL,
  brand       VARCHAR(12) NOT NULL,
  description VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS products_in_local (
  PRIMARY KEY(product_code, local_address),
  local_address   VARCHAR(50)   NOT NULL,
                  CONSTRAINT products_in_local_local_address_fk FOREIGN KEY (local_address) REFERENCES local_shops (address),
  product_code    INTEGER       NOT NULL,
                  CONSTRAINT products_in_local_product_code_fk FOREIGN KEY (product_code) REFERENCES products (code),
  expiration_date DATE          NOT NULL,
	exhibition_type VARCHAR(12)   NOT NULL,
	stock           NUMERIC(4, 0) NOT NULL
                  CONSTRAINT positive_stock CHECK (stock > 0)
);

CREATE TABLE IF NOT EXISTS promotions (
  PRIMARY KEY(id),
  id       SERIAL,
  validity BOOLEAN NOT NULL,
  value    MONEY   NOT NULL
);

CREATE TABLE IF NOT EXISTS has_promotion (
  PRIMARY KEY(promotion_id, product_code),
  promotion_id INTEGER NOT NULL,
               CONSTRAINT has_promotion_promotion_id_fk FOREIGN KEY (promotion_id) REFERENCES promotions (id),
	product_code INTEGER NOT NULL,
               CONSTRAINT has_promotion_product_code_fk FOREIGN KEY (product_code) REFERENCES products (code)
);

CREATE TABLE IF NOT EXISTS product_lists (
  PRIMARY KEY(date),
  date     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  validity BOOLEAN                     NOT NULL
);

CREATE TABLE IF NOT EXISTS product_in_list (
  PRIMARY KEY(product_code, list_date),
  product_code INTEGER NOT NULL,
               CONSTRAINT product_in_list_product_code_fkey FOREIGN KEY (product_code) REFERENCES products(code),
  list_date    DATE    NOT NULL,
               CONSTRAINT product_in_list_list_date_fkey FOREIGN KEY (list_date) REFERENCES product_lists(date)
	);

CREATE TABLE IF NOT EXISTS local_sells(
  PRIMARY KEY(id),
  id             SERIAL,
  client_id      INTEGER NOT NULL,
                 CONSTRAINT local_sells_client_id_fk FOREIGN KEY (client_id) REFERENCES customers (id),
  address        VARCHAR(50)  NOT NULL,
                 CONSTRAINT local_sells_address_fk FOREIGN KEY (address) REFERENCES local_shops(address),
  date_time      TIMESTAMP    NOT NULL,
  products_price MONEY        NOT NULL,
                 CONSTRAINT fk_local_sell_products_price CHECK (products_price > 0::MONEY),
  payment_method VARCHAR(20)  NOT NULL
);

CREATE TABLE IF NOT EXISTS local_sell_unit (
  PRIMARY KEY(sell_id, product_code),
	sell_id      INTEGER       NOT NULL,
               CONSTRAINT fk_local_sell_unit_sell_id FOREIGN KEY (sell_id) REFERENCES local_sells (id),
	product_code INTEGER       NOT NULL,
               CONSTRAINT fk_local_sell_unit_product_code FOREIGN KEY (product_code) REFERENCES products (code),
	amount       NUMERIC(3, 0) NOT NULL
               CONSTRAINT fk_local_sell_unit_amount CHECK (amount > 0::NUMERIC(3, 0)),
  subtotal     MONEY         NOT NULL,
               CONSTRAINT fk_local_sell_unit_subtotal CHECK (subtotal > 0::MONEY)
);

CREATE TABLE IF NOT EXISTS delivery_sells (
  PRIMARY KEY(id),
  id             SERIAL,
  client_id     INTEGER NOT NULL,
                 CONSTRAINT delivery_sells_client_id_fk FOREIGN KEY (client_id) REFERENCES delivery_customers (id),
  address        VARCHAR(50)  NOT NULL,
                 CONSTRAINT fk_delivery_sell_address FOREIGN KEY(address) REFERENCES local_shops(address),
  date_time      TIMESTAMP    NOT NULL,
  products_price MONEY        NOT NULL,
                 CONSTRAINT fk_delivery_sell_products_price CHECK (products_price > 0::MONEY),
  delivery_price MONEY        NOT NULL,
  payment_method VARCHAR(20)  NOT NULL
);

CREATE TABLE IF NOT EXISTS delivery_sell_unit(
  PRIMARY KEY(sell_id, product_code),
	sell_id      INTEGER       NOT NULL,
               CONSTRAINT fk_delivery_sell_unit_sell_id FOREIGN KEY (sell_id) REFERENCES delivery_sells (id),
	product_code INTEGER       NOT NULL,
               CONSTRAINT fk_delivery_sell_unit_product_code FOREIGN KEY (product_code) REFERENCES products (code),
	amount       NUMERIC(3, 0) NOT NULL,
               CONSTRAINT fk_delivery_sell_unit_amount CHECK (amount > 0::NUMERIC(3, 0)),
  subtotal     MONEY         NOT NULL,
               CONSTRAINT fk_delivery_sell_unit_subtotal CHECK (subtotal > 0::MONEY)
);

CREATE TABLE IF NOT EXISTS company_local_sells (
  PRIMARY KEY(sell_id, ruc),
  sell_id        INTEGER        NOT NULL,
                 CONSTRAINT fk_company_local_sell_sell_id FOREIGN KEY (sell_id) REFERENCES local_sells(id),
  ruc            NUMERIC(11, 0) NOT NULL,
                 CONSTRAINT fk_company_local_sell_ruc FOREIGN KEY (ruc) REFERENCES companies_info(ruc),
  invoice_number NUMERIC(11, 0) NOT NULL
);

CREATE TABLE IF NOT EXISTS company_delivery_sells (
  PRIMARY KEY(sell_id, ruc),
  sell_id        INTEGER        NOT NULL,
                 CONSTRAINT fk_company_delivery_sell_sell_id FOREIGN KEY (sell_id) REFERENCES delivery_sells(id),
  ruc            NUMERIC(11, 0) NOT NULL,
                 CONSTRAINT fk_company_delivery_sell_ruc FOREIGN KEY (ruc) REFERENCES companies_info(ruc),
  invoice_number NUMERIC(11, 0) NOT NULL
);

CREATE TABLE IF NOT EXISTS provisions (
  PRIMARY KEY(id),
  id          SERIAL,
  address     VARCHAR(50)    NOT NULL,
              CONSTRAINT fk_provisions_address FOREIGN KEY (address) REFERENCES local_shops(address),
  ruc         NUMERIC(11, 0) NOT NULL,
              CONSTRAINT fk_provisions_ruc FOREIGN KEY (ruc) REFERENCES companies_info(ruc),
  date_time   TIMESTAMP      NOT NULL,
  total_price MONEY          NOT NULL
              CONSTRAINT fk_provision_total_price CHECK (total_price > 0::MONEY)
);

CREATE TABLE IF NOT EXISTS provision_unit (
  PRIMARY KEY(provision_id, product_code),
	provision_id   INTEGER       NOT NULL,
                 CONSTRAINT fk_provision_unit_provision_id FOREIGN KEY (provision_id) REFERENCES provisions(id),
	product_code   INTEGER       NOT NULL,
                 CONSTRAINT fk_provision_unit_product_code FOREIGN KEY (product_code) REFERENCES products(code),
	amount         NUMERIC(3, 0) NOT NULL,
  subtotal       MONEY         NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
  PRIMARY KEY(dni),
  dni          NUMERIC(8,0) NOT NULL,
  name         VARCHAR(50)  NOT NULL,
  address      VARCHAR(50)  NOT NULL,
  phone_number VARCHAR(12)  NOT NULL,
  salary       MONEY        NOT NULL,
               CONSTRAINT fk_employee_salary CHECK (salary > 0::MONEY)
);

CREATE TABLE IF NOT EXISTS delivery_employees(
  PRIMARY KEY(dni),
  dni           NUMERIC(8,0) NOT NULL,
                CONSTRAINT fk_delivery_employee_dni FOREIGN KEY(dni) REFERENCES employees(dni),
  vehicle_plate VARCHAR(6) NOT NULL,
                CONSTRAINT fk_delivery_employee_vehicle_plate FOREIGN KEY(vehicle_plate) REFERENCES vehicles(plate)
);

CREATE TABLE IF NOT EXISTS local_employees(
  PRIMARY KEY(dni),
  dni          NUMERIC(8,0) NOT NULL,
               CONSTRAINT fk_local_employee_dni FOREIGN KEY(dni) REFERENCES employees(dni),
  shop_address VARCHAR(50) NOT NULL,
               CONSTRAINT fk_local_employee_shop_address FOREIGN KEY(shop_address) REFERENCES local_shops(address),
  position     VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS managers(
  PRIMARY KEY(dni),
  dni          NUMERIC(8,0) NOT NULL,
               CONSTRAINT fk_manager_dni FOREIGN KEY(dni) REFERENCES employees(dni),
  position     VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS shifts(
  PRIMARY KEY(employee_dni, week_day),
  employee_dni   NUMERIC(8, 0) NOT NULL,
                 CONSTRAINT fk_shift_employee_dni FOREIGN KEY(employee_dni) REFERENCES employees(dni),
  week_day       VARCHAR(10) NOT NULL,
  arrival_time   TIME        NOT NULL,
  departure_time TIME        NOT NULL,
                 CONSTRAINT fk_shift_departure_arrival CHECK (departure_time > arrival_time)
);

CREATE TABLE IF NOT EXISTS in_charge(
  PRIMARY KEY(shop_address, manager_dni),
  shop_address VARCHAR(50) NOT NULL,
               CONSTRAINT fk_in_charge_shop_address FOREIGN KEY(shop_address) REFERENCES local_shops(address),
  manager_dni  NUMERIC(8,0) NOT NULL,
               CONSTRAINT fk_in_charge_manager_dni FOREIGN KEY(manager_dni) REFERENCES managers(dni)
);
COMMIT;
