----------------------------------------------------
-- Calculate the sale that has generated the most revenue
-- Hint: use `ORDER BY` and `LIMIT`
-- * create 2 cols name and price for items purchased
-- * list rows with the highest price at the top
-- * get the first item
--
-- name   | price
-- -------|-------
-- Screen | 275.50
--
-- This works but computations are numerous
-- * can be simplified using `MAX`
----------------------------------------------------
SELECT items.name, items.price FROM items
INNER JOIN purchases ON items.id = purchases.item_id
ORDER BY items.price DESC
LIMIT 1;