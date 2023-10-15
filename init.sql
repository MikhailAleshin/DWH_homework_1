-- Creating manufacturers table
CREATE TABLE public.manufacturers (
    manufacturer_id SERIAL PRIMARY KEY,
    manufacturer_name VARCHAR(100) NOT NULL
);

-- Creating categories table
CREATE TABLE public.categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- Creating products table
CREATE TABLE public.products (
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category_id BIGINT REFERENCES categories(category_id),
    manufacturer_id BIGINT REFERENCES manufacturers(manufacturer_id)
);

-- Creating stores table
CREATE TABLE public.stores (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL
);

-- Creating deliveries table
CREATE TABLE public.deliveries (
    store_id BIGINT REFERENCES stores(store_id),
    product_id BIGINT REFERENCES products(product_id),
    delivery_date DATE NOT NULL,
    product_count INTEGER NOT NULL
);

-- Creating customers table
CREATE TABLE public.customers (
    customer_id SERIAL PRIMARY KEY,
    customer_fname VARCHAR(100) NOT NULL,
    customer_lname VARCHAR(100) NOT NULL
);

-- Creating purchases table
CREATE TABLE public.purchases (
    purchase_id SERIAL PRIMARY KEY,
    store_id BIGINT REFERENCES stores(store_id),
    customer_id BIGINT REFERENCES customers(customer_id),
    purchase_date DATE
);

-- Creating purchase_items table
CREATE TABLE public.purchase_items (
    product_id BIGINT REFERENCES products(product_id),
    purchase_id BIGINT REFERENCES purchases(purchase_id),
    product_count BIGINT NOT NULL,
    product_price NUMERIC(9,2) NOT NULL
);

-- Creating price_change table
CREATE TABLE public.price_change (
    product_id BIGINT PRIMARY KEY REFERENCES products(product_id),
    price_change_ts TIMESTAMP NOT NULL,
    new_price NUMERIC(9,2) NOT NULL
);

CREATE VIEW public.gmv_view AS
SELECT p.store_id, pr.category_id, SUM(pi.product_price * pi.product_count) AS GMV
FROM purchase_items pi
INNER JOIN purchases p ON pi.purchase_id = p.purchase_id
INNER JOIN products pr on pr.product_id = pi.product_id
GROUP BY store_id, category_id;