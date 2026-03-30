-- E-Commerce database schema for this project
-- Matches table names used in PHP files (including `card_details`)

CREATE DATABASE IF NOT EXISTS signupforms;
USE signupforms;

-- -----------------------------
-- Master tables
-- -----------------------------
CREATE TABLE IF NOT EXISTS categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_title VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS brands (
  brand_id INT AUTO_INCREMENT PRIMARY KEY,
  brand_title VARCHAR(120) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_title VARCHAR(255) NOT NULL,
  product_description TEXT NOT NULL,
  product_keywords TEXT NOT NULL,
  category_id INT NOT NULL,
  brand_id INT NOT NULL,
  product_image1 VARCHAR(255) NOT NULL,
  product_image2 VARCHAR(255) NOT NULL,
  product_image3 VARCHAR(255) NOT NULL,
  product_price DECIMAL(10,2) NOT NULL,
  date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(50) NOT NULL DEFAULT 'true',
  INDEX idx_products_category (category_id),
  INDEX idx_products_brand (brand_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------
-- Cart and user tables
-- -----------------------------
CREATE TABLE IF NOT EXISTS card_details (
  cart_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  ip_address VARCHAR(100) NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  INDEX idx_card_product (product_id),
  INDEX idx_card_ip (ip_address)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_table (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  user_email VARCHAR(150) NOT NULL UNIQUE,
  user_password VARCHAR(255) NOT NULL,
  user_image VARCHAR(255) DEFAULT NULL,
  user_ip VARCHAR(100) DEFAULT NULL,
  user_address VARCHAR(255) DEFAULT NULL,
  user_mobile VARCHAR(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  amount_due DECIMAL(10,2) NOT NULL,
  invoice_number BIGINT NOT NULL,
  total_products INT NOT NULL,
  order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  order_status VARCHAR(50) NOT NULL DEFAULT 'pending',
  INDEX idx_orders_user (user_id),
  INDEX idx_orders_invoice (invoice_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS orders_pending (
  order_pending_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  invoice_number BIGINT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  order_status VARCHAR(50) NOT NULL DEFAULT 'pending',
  INDEX idx_pending_user (user_id),
  INDEX idx_pending_product (product_id),
  INDEX idx_pending_invoice (invoice_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS user_payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  invoice_number BIGINT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_mode VARCHAR(100) NOT NULL,
  date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_payments_order (order_id),
  INDEX idx_payments_invoice (invoice_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS admin_table (
  admin_id INT AUTO_INCREMENT PRIMARY KEY,
  admin_name VARCHAR(100) NOT NULL UNIQUE,
  admin_email VARCHAR(150) NOT NULL UNIQUE,
  admin_password VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------
-- Optional seed data
-- -----------------------------
INSERT INTO categories (category_title)
SELECT 'Electronics' WHERE NOT EXISTS (
  SELECT 1 FROM categories WHERE category_title = 'Electronics'
);

INSERT INTO brands (brand_title)
SELECT 'Apple' WHERE NOT EXISTS (
  SELECT 1 FROM brands WHERE brand_title = 'Apple'
);

INSERT INTO categories (category_title)
SELECT 'Wearables' WHERE NOT EXISTS (
  SELECT 1 FROM categories WHERE category_title = 'Wearables'
);

INSERT INTO categories (category_title)
SELECT 'Audio' WHERE NOT EXISTS (
  SELECT 1 FROM categories WHERE category_title = 'Audio'
);

INSERT INTO brands (brand_title)
SELECT 'Samsung' WHERE NOT EXISTS (
  SELECT 1 FROM brands WHERE brand_title = 'Samsung'
);

INSERT INTO brands (brand_title)
SELECT 'Sony' WHERE NOT EXISTS (
  SELECT 1 FROM brands WHERE brand_title = 'Sony'
);

INSERT INTO categories (category_title)
SELECT 'Fashion' WHERE NOT EXISTS (
  SELECT 1 FROM categories WHERE category_title = 'Fashion'
);

INSERT INTO categories (category_title)
SELECT 'Footwear' WHERE NOT EXISTS (
  SELECT 1 FROM categories WHERE category_title = 'Footwear'
);

INSERT INTO categories (category_title)
SELECT 'Groceries' WHERE NOT EXISTS (
  SELECT 1 FROM categories WHERE category_title = 'Groceries'
);

INSERT INTO brands (brand_title)
SELECT 'Levis' WHERE NOT EXISTS (
  SELECT 1 FROM brands WHERE brand_title = 'Levis'
);

INSERT INTO brands (brand_title)
SELECT 'Nike' WHERE NOT EXISTS (
  SELECT 1 FROM brands WHERE brand_title = 'Nike'
);

INSERT INTO brands (brand_title)
SELECT 'Farm Fresh' WHERE NOT EXISTS (
  SELECT 1 FROM brands WHERE brand_title = 'Farm Fresh'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Apple iPhone 15',
  'Latest generation smartphone with high performance and excellent camera.',
  'iphone apple smartphone ios 15',
  (SELECT category_id FROM categories WHERE category_title = 'Electronics' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Apple' LIMIT 1),
  'apple1.avif',
  'apple1.avif',
  'apple1.avif',
  999.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Apple iPhone 15'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Galaxy Fit Smart Band',
  'Comfortable fitness smart band with health and sleep tracking features.',
  'samsung smartband wearable fitness',
  (SELECT category_id FROM categories WHERE category_title = 'Wearables' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Samsung' LIMIT 1),
  'apple1.avif',
  'apple1.avif',
  'apple1.avif',
  149.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Galaxy Fit Smart Band'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Sony Wireless Headphones',
  'Clear audio, deep bass, and long battery life for daily listening.',
  'sony headphones wireless audio music',
  (SELECT category_id FROM categories WHERE category_title = 'Audio' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Sony' LIMIT 1),
  'apple1.avif',
  'apple1.avif',
  'apple1.avif',
  229.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Sony Wireless Headphones'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Classic Blue Jeans',
  'Comfort-fit denim jeans for everyday style and durability.',
  'jeans denim fashion casual',
  (SELECT category_id FROM categories WHERE category_title = 'Fashion' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Levis' LIMIT 1),
  'jeans1.jpg',
  'jeans2.jpg',
  'jeans3.webp',
  79.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Classic Blue Jeans'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Summer Floral Dress',
  'Lightweight floral dress designed for comfort and modern style.',
  'dress frock women fashion summer',
  (SELECT category_id FROM categories WHERE category_title = 'Fashion' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Levis' LIMIT 1),
  'frock1.webp',
  'frock2.webp',
  'frock3.jpg',
  65.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Summer Floral Dress'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Street Run Sneakers',
  'Breathable sneakers with cushioned soles for daily walks and workouts.',
  'sneakers shoes running footwear',
  (SELECT category_id FROM categories WHERE category_title = 'Footwear' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Nike' LIMIT 1),
  'shoes1.jpg',
  'shoes2.jpg',
  'shoes3.webp',
  120.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Street Run Sneakers'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Fresh Mango Pack',
  'Naturally sweet mango pack sourced from seasonal farms.',
  'mango fruit groceries fresh',
  (SELECT category_id FROM categories WHERE category_title = 'Groceries' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Farm Fresh' LIMIT 1),
  'mango.jpg',
  'mango1.webp',
  'mango4.jpg',
  18.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Fresh Mango Pack'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Organic Apple Basket',
  'Crisp and fresh apples, ideal for daily healthy snacks.',
  'apple organic fruit groceries',
  (SELECT category_id FROM categories WHERE category_title = 'Groceries' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Farm Fresh' LIMIT 1),
  'apple1.avif',
  'apple2.webp',
  'apple3.webp',
  24.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Organic Apple Basket'
);

INSERT INTO products (
  product_title,
  product_description,
  product_keywords,
  category_id,
  brand_id,
  product_image1,
  product_image2,
  product_image3,
  product_price,
  date,
  status
)
SELECT
  'Fresh Capsicum Combo',
  'Farm-picked capsicum combo pack with vibrant color and crunch.',
  'capsicum vegetables groceries combo',
  (SELECT category_id FROM categories WHERE category_title = 'Groceries' LIMIT 1),
  (SELECT brand_id FROM brands WHERE brand_title = 'Farm Fresh' LIMIT 1),
  'capsi1.webp',
  'capsi2.webp',
  'capsi3.webp',
  14.00,
  NOW(),
  'true'
WHERE NOT EXISTS (
  SELECT 1 FROM products WHERE product_title = 'Fresh Capsicum Combo'
);
