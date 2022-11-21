CREATE TABLE IF NOT EXISTS customer_details(
  PRIMARY KEY(dni),
  dni         NUMERIC(8, 0)   NOT NULL,
  name        VARCHAR(50)     NOT NULL,
  visit_count NUMERIC(4, 0)   NOT NULL,
);

CREATE TABLE IF NOT EXISTS customers (
  PRIMARY KEY(id),
  id SERIAL
);

CREATE TABLE IF NOT EXISTS delivery_customers(
  PRIMARY KEY (id),
  id SERIAL,
  addres       VARCHAR (50)  NOT NULL,
  phone_number VARCHAR (12)  NOT NULL
);

CREATE TABLE IF NOT EXISTS local_shops(
  PRIMARY KEY(address),
  address      VARCHAR(50)    NOT NULL,
  phone_number VARCHAR(12)    NOT NULL,
  local_size   VARCHAR(10)    NOT NULL
);

CREATE TABLE IF NOT EXISTS companies_info (
  PRIMARY KEY(ruc),
  ruc            NUMERIC(11, 0) NOT NULL,
  email          VARCHAR(50)    NOT NULL,
  name           VARCHAR(50)    NOT NULL
)

CREATE TABLE IF NOT EXISTS promotions (
  PRIMARY KEY(id),
  id       SERIAL,
  validity BOOLEAN NOT NULL,
  value    MONEY   NOT NULL
);

CREATE TABLE IF NOT EXISTS product_lists (
  PRIMARY KEY(date),
  date     TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  validity BOOLEAN                     NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
  PRIMARY KEY(dni),
  dni          NUMERIC(8,0) NOT NULL,
  nombre       VARCHAR(50)  NOT NULL,
  address      VARCHAR(50)  NOT NULL
  phone_number VARCHAR(12)  NOT NULL,
  salary       MONEY        NOT NULL
               CONSTRAINT fk_employee_salary CHECK (salary > 0::MONEY),
);


CREATE TABLE IF NOT EXISTS products (
  PRIMARY KEY(code),
  code        SERIAL,
  price       MONEY       NOT NULL,
              CONSTRAINT products_positive_price CHECK (price > 0::MONEY),
  category    VARCHAR(12) NOT NULL,
  brand       VARCHAR(12) NOT NULL,
  description VARCHAR(50) NOT NULL
);

