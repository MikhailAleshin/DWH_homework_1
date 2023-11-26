CREATE TABLE public.manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL,
    manufacturer_legal_entity VARCHAR(100) NOT NULL
);

CREATE TABLE public.categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE public.products (
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_picture_url VARCHAR(255) NOT NULL,
    product_description VARCHAR(255) NOT NULL,
    product_age_restriction INT NOT NULL,
    category_id BIGINT REFERENCES categories(category_id),
    manufacturer_id BIGINT REFERENCES manufacturers(manufacturer_id)
);

CREATE TABLE public.stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    store_country VARCHAR(255) NOT NULL,
    store_city VARCHAR(255) NOT NULL,
    store_address VARCHAR(255) NOT NULL
);

CREATE TABLE public.deliveries (
    delivery_id BIGINT PRIMARY KEY,
    store_id BIGINT REFERENCES stores(store_id),
    product_id BIGINT REFERENCES products(product_id),
    delivery_date DATE NOT NULL,
    product_count INTEGER NOT NULL
);

CREATE TABLE public.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_fname VARCHAR(100) NOT NULL,
    customer_lname VARCHAR(100) NOT NULL,
    customer_gender VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(100) NOT NULL
);

CREATE TABLE public.purchases (
    purchase_id SERIAL PRIMARY KEY,
    store_id BIGINT REFERENCES stores(store_id),
    customer_id BIGINT REFERENCES customers(customer_id),
    purchase_date DATE,
    purchase_payment_type DATE
);

CREATE TABLE public.purchase_items (
    product_id BIGINT REFERENCES products(product_id),
    purchase_id BIGINT REFERENCES purchases(purchase_id),
    product_count BIGINT NOT NULL,
    product_price NUMERIC(9,2) NOT NULL
);

CREATE TABLE public.price_change (
    product_id BIGINT PRIMARY KEY REFERENCES products(product_id),
    price_change_ts TIMESTAMP NOT NULL,
    new_price NUMERIC(9,2) NOT NULL
);

CREATE SCHEMA dwh_detailed;

CREATE TABLE dwh_detailed.hub_products (
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.sat_price_change (
    product_id BIGINT REFERENCES hub_products(product_id),
    price_change_ts TIMESTAMP NOT NULL,
    new_price NUMERIC(9,2) NOT NULL,
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE,
    PRIMARY KEY (product_id, load_dts)
);

CREATE TABLE dwh_detailed.hub_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.lnk_products_manufacturers (
	product_manufacturers_id SERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES hub_products(product_id),
    manufacturer_id BIGINT REFERENCES hub_manufacturers(manufacturer_id),
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.hub_manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL,
    load_dts DATE NOT null,
    rec_src VARCHAR(100) NOT NULL
);

CREATE TABLE dwh_detailed.sat_manufacturers (
    manufacturer_id BIGINT REFERENCES hub_manufacturers(manufacturer_id),
    manufacturer_legal_entity VARCHAR(100) NOT null,
    load_dts DATE NOT NULL,
    rec_src VARCHAR(100) NOT null,
    PRIMARY KEY (manufacturer_id, load_dts)
);


CREATE TABLE dwh_detailed.lnk_products_categories (
	lnk_product_category_id SERIAL PRIMARY KEY,
    category_id BIGINT REFERENCES hub_categories(category_id),
    product_id BIGINT REFERENCES hub_products(product_id),
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.hub_stores (
    hub_store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.sat_stores (
    store_id BIGINT REFERENCES hub_stores(store_id),
    store_country VARCHAR(255) NOT NULL,
    store_city VARCHAR(255) NOT NULL,
    store_address VARCHAR(255) NOT NULL,
    load_dts DATE NOT null,
    rec_src VARCHAR(100) NOT NULL,
    PRIMARY KEY (store_id, load_dts)
);


CREATE TABLE dwh_detailed.lnk_stores_products (
	delivery_id SERIAL PRIMARY KEY,
    store_id BIGINT REFERENCES hub_stores(store_id),
    product_id BIGINT REFERENCES hub_products(product_id),
    delivery_date DATE NOT NULL,
    product_count INTEGER NOT NULL,
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);


CREATE TABLE dwh_detailed.hub_customers (
    customer_id SERIAL PRIMARY KEY,
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.sat_customers (
    customer_id BIGINT REFERENCES hub_customers(customer_id),
    customer_fname VARCHAR(100) NOT NULL,
    customer_lname VARCHAR(100) NOT NULL,
    customer_gender VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(100) NOT NULL,
    load_dts DATE NOT null,
    rec_src VARCHAR(100) NOT NULL,
    PRIMARY KEY (customer_id, load_dts)
);

CREATE TABLE dwh_detailed.hub_purchases (
    purchase_id SERIAL PRIMARY KEY,
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);


CREATE TABLE dwh_detailed.lnk_purchases_products (
	purchase_product_id SERIAL PRIMARY KEY,
    product_id BIGINT REFERENCES hub_products(product_id),
    purchase_id BIGINT REFERENCES hub_purchases(purchase_id),
    product_count BIGINT NOT NULL,
    product_price NUMERIC(9,2) NOT NULL,
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.lnk_purchases_stores (
	purchase_store_id SERIAL PRIMARY KEY,
    store_id BIGINT REFERENCES hub_stores(store_id),
    purchase_id BIGINT REFERENCES hub_purchases(purchase_id),
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.lnk_purchases_customers (
	purchase_store_id SERIAL PRIMARY KEY,
    purchase_id BIGINT REFERENCES purchases(purchase_id),
    customer_id BIGINT REFERENCES customers(customer_id),
    rec_src VARCHAR(100) NOT NULL,
    load_dts DATE
);

CREATE TABLE dwh_detailed.sat_purchases (
    purchase_id BIGINT REFERENCES hub_purchases(purchase_id),
    purchase_date DATE,
    purchase_payment_type VARCHAR(100) NOT NULL,
    load_dts DATE NOT null,
    rec_src VARCHAR(100) NOT NULL,
    PRIMARY KEY (purchase_id, load_dts)
);