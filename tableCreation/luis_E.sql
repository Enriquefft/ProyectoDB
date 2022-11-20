CREATE TABLE IF NOT EXISTS customer_details(
  PRIMARY KEY(dni),
  dni         NUMERIC(8, 0)   NOT NULL,
  name        VARCHAR(50)     NOT NULL,
  visit_count NUMERIC(4, 0)   NOT NULL,
);

CREATE TABLE IF NOT EXISTS customers (
  id SERIAL
);

CREATE TABLE IF NOT EXISTS delivery_customers(
  id SERIAL,
  addres       VARCHAR (50),
  phone_number VARCHAR (12)
);

CREATE TABLE IF NOT EXISTS local_shops(
  PRIMARY KEY(address),
  address      VARCHAR(50)    NOT NULL,
  phone_number VARCHAR(12)    NOT NULL,
  local_size   VARCHAR(10)    NOT NULL
);

CREATE TABLE IF NOT EXISTS provider_companies (
  PRIMARY KEY(ruc),
  ruc            NUMERIC(11, 0) NOT NULL,
  email          VARCHAR(50)    NOT NULL,
  name           VARCHAR(50)    NOT NULL
  provides_count INTEGER        NOT NULL
);

CREATE TABLE IF NOT EXISTS customer_companies (
  PRIMARY KEY(ruc),
  ruc            NUMERIC(11, 0) NOT NULL,
  email          VARCHAR(50)    NOT NULL,
  name           VARCHAR(50)    NOT NULL
);

CREATE TABLE IF NOT EXISTS companies_info (
  PRIMARY KEY(ruc, address),
  ruc            NUMERIC(11, 0)  NOT NULL,
  address        VARCHAR(50)     NOT NULL,
  phone_number   VARCHAR(12)     NOT NULL,
)

CREATE TABLE IF NOT EXISTS products (
  PRIMARY KEY(code),
  code        SERIAL,
  price       MONEY       NOT NULL,
  category    VARCHAR(12) NOT NULL,
  brand       VARCHAR(12) NOT NULL,
  description VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS products_in_local (
  PRIMARY KEY(product_code, local_address),
  local_address   VARCHAR(50)   NOT NULL,
  product_code    INTEGER       NOT NULL,
  expiration_date DATE          NOT NULL,
	exhibition_type VARCHAR(12)   NOT NULL,
	stock           NUMERIC(4, 0) NOT NULL
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
	product_code INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS product_lists (
  PRIMARY KEY(date),
  date     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  validity BOOLEAN                     NOT NULL
);

CREATE TABLE IF NOT EXISTS product_in_list (
  PRIMARY KEY(product_code, list_date),
  product_code INTEGER NOT NULL,
  list_date    DATE    NOT NULL
	);

CREATE TABLE IF NOT EXISTS local_sells(
  PRIMARY KEY(id),
  id             SERIAL
  address        VARCHAR(50)  NOT NULL,
  date_time      TIMESTAMP    NOT NULL,
  products_price MONEY        NOT NULL,
  payment_method VARCHAR(20)  NOT NULL
);

CREATE TABLE IF NOT EXISTS local_sell_unit (
  PRIMARY KEY(sell_id, product_code),
	sell_id      INTEGER       NOT NULL,
	product_code INTEGER       NOT NULL,
	amount       NUMERIC(3, 0) NOT NULL
  subtotal     MONEY         NOT NULL,
);

CREATE TABLE IF NOT EXISTS delivery_sells (
  PRIMARY KEY(id),
  id             SERIAL
  address        VARCHAR(50)  NOT NULL,
                 CONSTRAINT fk_delivery_sell_address
                 FOREIGN KEY(address) REFERENCES locals(address),
  date_time      TIMESTAMP    NOT NULL,
  products_price MONEY        NOT NULL,
  delivery_price MONEY        NOT NULL,
  payment_method VARCHAR(20)  NOT NULL
);

CREATE TABLE IF NOT EXISTS delivery_sell_unit(
  PRIMARY KEY(sell_id, product_code),
	sell_id      INTEGER       NOT NULL,
	product_code INTEGER       NOT NULL,
	amount       NUMERIC(3, 0) NOT NULL
  subtotal     MONEY         NOT NULL,
);

CREATE TABLE IF NOT EXISTS company_local_sells (
  PRIMARY KEY(id, ruc),
  id             INTEGER        NOT NULL,
  ruc            NUMERIC(11, 0) NOT NULL,
  invoice_number NUMERIC(11, 0) NOT NULL
);

CREATE TABLE IF NOT EXISTS company_delivery_sells (
  PRIMARY KEY(id, ruc),
  id             INTEGER        NOT NULL,
  ruc            NUMERIC(11, 0) NOT NULL,
  invoice_number NUMERIC(11, 0) NOT NULL
);

CREATE TABLE IF NOT EXISTS provisions (
  PRIMARY KEY(id),
  id          SERIAL,
  address     VARCHAR(50)    NOT NULL,
  ruc         NUMERIC(11, 0) NOT NULL,
  date_time   TIMESTAMP      NOT NULL,
  total_price MONEY          NOT NULL
);

CREATE TABLE IF NOT EXISTS provision_unit (
  PRIMARY KEY(provision_id, product_code),
	provision_id   INTEGER       NOT NULL,
	product_code   INTEGER       NOT NULL,
	amount         NUMERIC(3, 0) NOT NULL
  subtotal       MONEY         NOT NULL,
);

CREATE TABLE IF NOT EXISTS employees (
  PRIMARY KEY(dni),
  dni          NUMERIC(8,0) NOT NULL,
  nombre       VARCHAR(50)  NOT NULL,
  address      VARCHAR(50)  NOT NULL
  phone_number VARCHAR(12)  NOT NULL,
  salary       INT          NOT NULL
);

CREATE TABLE IF NOT EXISTS delivery_employees(
  PRIMARY KEY(dni),
  dni           NUMERIC(8,0) NOT NULL,
  vehicle_plate VARCHAR(6) NOT NULL
);

CREATE TABLE IF NOT EXISTS local_employees(
  PRIMARY KEY(dni),
  dni          NUMERIC(8,0) NOT NULL,
  shop_address VARCHAR(50) NOT NULL,
  position     VARCHAR(15) NOT NULL
);

CREATE TABLE IF NOT EXISTS managers(
  PRIMARY KEY(dni),
  dni          NUMERIC(8,0) NOT NULL,
  position     VARCHAR(15) NOT NULL
);

--ENTIDAD DEBIL
CREATE TABLE IF NOT EXISTS shifts(
  PRIMARY KEY(worker_dni, week_day),
  worker_dni     VARCHAR(50) NOT NULL,
  week_day       VARCHAR(10) NOT NULL,
  arrival_time   TIME        NOT NULL,
  departure_time TIME        NOT NULL
);

CREATE TABLE IF NOT EXISTS in_charge(
  PRIMARY KEY(shop_address, manager_dni),
  shop_address VARCHAR(50) NOT NULL,
  manager_dni  NUMERIC(8,0) NOT NULL
);

CREATE TABLE IF NOT EXISTS vehicles(
  PRIMARY KEY(plate),
  plate          VARCHAR(6)    NOT NULL,
  shop_address   VARCHAR(50)   NOT NULL,
  delivery_count NUMERIC(4, 0) NOT NULL
);

--pk
ALTER TABLE IF EXISTS worker
    ADD CONSTRAINT pk_worker PRIMARY KEY (id,person_dni);
	
ALTER TABLE IF EXISTS delivery_man
    ADD CONSTRAINT pk_delivery_man PRIMARY KEY (worker_id);
	
ALTER TABLE IF EXISTS shop_worker
    ADD CONSTRAINT pk_shop_worker PRIMARY KEY (worker_id);
	
ALTER TABLE IF EXISTS manager
    ADD CONSTRAINT pk_manager PRIMARY KEY (worker_id);
	
ALTER TABLE IF EXISTS in_charge
    ADD CONSTRAINT pk_in_charge PRIMARY KEY (shop_address,manager_id);
	
ALTER TABLE IF EXISTS shift
    ADD CONSTRAINT pk_shift PRIMARY KEY (worker_id,week_day);
	
ALTER TABLE IF EXISTS vehicle
    ADD CONSTRAINT pk_vehicle PRIMARY KEY (plate);
	
ALTER TABLE IF EXISTS shop
    ADD CONSTRAINT pk_shop PRIMARY KEY (address);
ALTER TABLE IF EXISTS has_promotion
    ADD PRIMARY KEY (promotion_id, product_code);
ALTER TABLE IF EXISTS isin
	ADD PRIMARY KEY (product_code, product_list_date);
ALTER TABLE IF EXISTS products_sell
	ADD PRIMARY KEY (local_direction, product_code);	
ALTER TABLE IF EXISTS person_detail
	ADD PRIMARY KEY (dni);	
ALTER TABLE local_sell ADD CONSTRAINT pk_venta_local PRIMARY KEY (id);

ALTER TABLE companies ADD CONSTRAINT pk_empresa PRIMARY KEY (ruc);

ALTER TABLE provisions ADD CONSTRAINT pk_pedido PRIMARY KEY (id);
ALTER TABLE IF EXISTS products ADD PRIMARY KEY (code);
ALTER TABLE IF EXISTS products_list ADD PRIMARY KEY (date);
ALTER TABLE IF EXISTS promotions ADD PRIMARY KEY (id);
--restricciones
ALTER TABLE IF EXISTS worker
    ADD UNIQUE (id);

ALTER TABLE IF EXISTS client_company
    ADD UNIQUE (ruc);

ALTER TABLE IF EXISTS provider_company
    ADD UNIQUE (ruc);

ALTER TABLE IF EXISTS delivery_sell
     ADD CHECK ( total > 0::MONEY );

ALTER TABLE IF EXISTS local_sell
     ADD CHECK ( total_price > 0::MONEY );

ALTER TABLE worker ADD CONSTRAINT trabajador_salario CHECK (salary > 0);

ALTER TABLE shift ADD CONSTRAINT llegada_salida CHECK (departure_time > arrival_time);

ALTER TABLE sell_unit_local ADD CONSTRAINT subtotal_local CHECK (subtotal > 0::MONEY);

ALTER TABLE sell_unit_local ADD CONSTRAINT monto_local CHECK (amount > 0);

ALTER TABLE sell_unit_delivery ADD CONSTRAINT subtotal_delivery CHECK (subtotal > 0::MONEY);

ALTER TABLE sell_unit_delivery ADD CONSTRAINT monto_delivery CHECK (amount > 0);

ALTER TABLE provisions ADD CONSTRAINT precio_total CHECK (total_price > 0::MONEY);

ALTER TABLE products_sell ADD CONSTRAINT stock CHECK (stock >= 0);

ALTER TABLE products ADD CONSTRAINT precio CHECK (price > 0::MONEY);

--fk
ALTER TABLE IF EXISTS worker
ADD CONSTRAINT fk_worker_person FOREIGN KEY (person_dni)
REFERENCES person_detail (dni);

ALTER TABLE IF EXISTS delivery_man
ADD CONSTRAINT fk_delivery_man_worker FOREIGN KEY (worker_id)
REFERENCES worker (id);

ALTER TABLE IF EXISTS delivery_man
ADD CONSTRAINT fk_delivery_man_vehicle FOREIGN KEY (vehicle_plate)
REFERENCES vehicle (plate);

ALTER TABLE IF EXISTS shop_worker
ADD CONSTRAINT fk_shop_worker_worker FOREIGN KEY (worker_id)
REFERENCES worker (id);

ALTER TABLE IF EXISTS shop_worker
ADD CONSTRAINT fk_shop_worker_shop FOREIGN KEY (shop_address)
REFERENCES shop (address);

ALTER TABLE IF EXISTS manager
ADD CONSTRAINT fk_manager_worker FOREIGN KEY (worker_id)
REFERENCES worker (id);

ALTER TABLE IF EXISTS in_charge
ADD CONSTRAINT fk_in_charge_shop FOREIGN KEY (shop_address)
REFERENCES shop (address);

ALTER TABLE IF EXISTS in_charge
ADD CONSTRAINT fk_in_charge_manager FOREIGN KEY (manager_id)
REFERENCES manager (worker_id);

ALTER TABLE IF EXISTS shift
ADD CONSTRAINT fk_shift_worker FOREIGN KEY (worker_id)
REFERENCES worker (id);

ALTER TABLE IF EXISTS vehicle
ADD CONSTRAINT fk_vehicle_shop FOREIGN KEY (shop_address)
REFERENCES shop (address);

ALTER TABLE local_sell ADD CONSTRAINT fk_venta_local FOREIGN KEY (address) REFERENCES shop (address);

ALTER TABLE company_local_buy ADD CONSTRAINT pk_empresa_compra_local FOREIGN KEY (ruc) REFERENCES client_company(ruc);

ALTER TABLE company_local_buy ADD CONSTRAINT fk_empresa_compra_local FOREIGN KEY (id) REFERENCES local_sell(id);

ALTER TABLE company_delivery_sell ADD CONSTRAINT fk_empresa_compra_local FOREIGN KEY (ruc) REFERENCES client_company(ruc);

ALTER TABLE company_delivery_sell ADD CONSTRAINT fk_empresa_compra_local1 FOREIGN KEY (id) REFERENCES local_sell(id);

ALTER TABLE provider_company ADD CONSTRAINT fk_empresa_proveedora FOREIGN KEY (ruc) REFERENCES companies(ruc);

ALTER TABLE provisions ADD CONSTRAINT fk_pedido FOREIGN KEY (address) REFERENCES shop (address);

ALTER TABLE IF EXISTS isin ADD CONSTRAINT fk_product_list_date FOREIGN KEY (product_list_date) REFERENCES products_list (date);

ALTER TABLE IF EXISTS isin ADD CONSTRAINT fk_product_code FOREIGN KEY (product_code) REFERENCES products (code);

ALTER TABLE IF EXISTS products_sell ADD CONSTRAINT prod1ucts_sell1 FOREIGN KEY (product_code) REFERENCES products (code);

ALTER TABLE IF EXISTS products_sell ADD CONSTRAINT prod1ucts_sell2 FOREIGN KEY (local_direction) REFERENCES shop (address);

ALTER TABLE IF EXISTS has_promotion ADD CONSTRAINT has_promotion1 FOREIGN KEY (product_code) REFERENCES products (code);

ALTER TABLE IF EXISTS has_promotion ADD CONSTRAINT has_promotion2 FOREIGN KEY (promotion_id) REFERENCES promotions (id);
