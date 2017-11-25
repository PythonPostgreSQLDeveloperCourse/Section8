----------------------------------------------------
-- Calculate the sale that has generated the most revenue
-- using `MAX`
-- 
-- '275.50'
-- 
-- Works but we lose out on getting the name
----------------------------------------------------
SELECT MAX(items.price) FROM items
INNER JOIN purchases ON items.id = purchases.item_id;