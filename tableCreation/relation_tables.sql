CREATE TABLE IF NOT EXISTS inStorePurchase (
  store_sale_id INT NOT NULL,
  shop_client_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS deliveryPurchase (
  delivery_sale_id INT NOT NULL,
  delivery_client_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS inCharge (
  shop_address VARCHAR(50) NOT NULL,
  manager_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS sellProduct (
  shop_address INT NOT NULL,
  shop_client_id INT NOT NULL,
  expiration_date timestamp,
  stock INT,
  exhibition_type VARCHAR(12),
);

CREATE TABLE IF NOT EXISTS isIn (
  product_code INT NOT NULL,
  products_list_date timestamp
);

CREATE TABLE IF NOT EXISTS hasPromotion (
  product_code INT NOT NULL,
  promotion_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS companyDeliverySale (
  client_company_ruc INT NOT NULL,
  delivery_sale_id INT NOT NULL,
  invoice VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS companyInStoreSale (
  client_company_ruc INT NOT NULL,
  store_sale_id INT NOT NULL,
  invoice VARCHAR(10)
);