-- 1. 既存のテーブルがあれば削除（クリーンアップ）
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS users;

-- 2. ユーザーテーブル作成
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. 商品テーブル作成
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) CHECK (price >= 0),
    stock_quantity INTEGER DEFAULT 0,
    category VARCHAR(50)
);

-- 4. 注文テーブル作成（ユーザーと紐付け）
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending'
);

-- 5. 注文明細テーブル作成（注文と商品を紐付け：中間テーブル）
CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL
);

-- 6. 検索高速化のためのインデックス作成
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- 7. テスト用データの挿入
INSERT INTO users (username, email) VALUES
('tanaka_taro', 'tanaka@example.com'),
('sato_hanako', 'sato@example.com'),
('suzuki_ichiro', 'suzuki@example.com');

INSERT INTO products (product_name, price, stock_quantity, category) VALUES
('ワイヤレスマウス', 2500.00, 50, '周辺機器'),
('メカニカルキーボード', 12000.00, 20, '周辺機器'),
('27インチモニター', 35000.00, 15, '家電'),
('USB-Cハブ', 4500.00, 100, '周辺機器');

INSERT INTO orders (user_id, status) VALUES
(1, 'shipped'),
(2, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 2500.00),
(1, 4, 2, 4500.00),
(2, 2, 1, 12000.00);

-- 8. 動作確認用の結合（JOIN）クエリ
SELECT 
    u.username, 
    o.order_id, 
    p.product_name, 
    oi.quantity, 
    (oi.quantity * oi.unit_price) AS subtotal
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;
