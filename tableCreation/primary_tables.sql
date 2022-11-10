CREATE TABLE IF NOT EXISTS clients (
  id INT NOT NULL AUTO_INCREMENT
);

CREATE TABLE IF NOT EXISTS shops(
  address VARCHAR(50) NOT NULL
  phone_number VARCHAR(12) NOT NULL
  shop_size VARCHAR(10) NOT NULL DEFAULT small
);
CREATE TABLE IF NOT EXISTS products (
  code INT NOT NULL AUTO_INCREMENT,
  price MONEY NOT NULL, -- postgresql type
  category VARCHAR(12) NOT NULL DEFAULT "uncategorized",
  brand VARCHAR(12) NOT NULL DEFAULT "no_brand",
  description VARCHAR(50) NOT NULL DEFAULT "no_description"
);
CREATE TABLE IF NOT EXISTS promotions (
  id INT NOT NULL AUTO_INCREMENT,
  validity BOOLEAN NOT NULL DEFAULT false,
  value DECIMAL(5, 2, 2) NOT NULL DEFAULT 0.00
);
CREATE TABLE IF NOT EXISTS products_list (
  date DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS companies (
  ruc NUMERIC(11, 0) NOT NULL,
  address VARCHAR(50) NOT NULL,
  social_reason VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  phone_number VARCHAR(12) NOT NULL
  n
);
