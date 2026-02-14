-- 登録されたユーザー一覧
SELECT * FROM users;

-- 登録された商品一覧
SELECT * FROM products;

-- 注文データの一覧
SELECT * FROM orders;

SELECT 
    u.username AS 顧客名, 
    p.product_name AS 購入商品, 
    oi.quantity AS 個数, 
    p.price AS 単価,
    (oi.quantity * p.price) AS 合計金額
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;



SELECT * FROM products WHERE price >= 5000;

select * 
from products 
order by price desc;

-- 価格が安い順に表示
SELECT * FROM products ORDER BY price ASC;

-- 価格が安い順に表示
SELECT * FROM products ORDER BY price DESC;

SELECT * FROM products ORDER BY category ASC, price ASC;

-- 1番目の列（通常はIDなど）で並び替え
SELECT * FROM products ORDER BY 1;

SELECT * FROM products 
WHERE category = '周辺機器' 
ORDER BY price DESC;

-- 練習問題
--「users テーブルから、created_at（作成日時）が新しい順にユーザーを表示してください」

select *
from users 
order by created_at desc;

--「ユーザーを名前（username）の**あいうえお順（アルファベット順）**に並べるにはどう書けばいいでしょうか？」

select *
from users
order by username asc;


