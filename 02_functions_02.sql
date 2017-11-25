----------------------------------------------------
-- Average price of all items purchased
-- '72.2587500000000000'
----------------------------------------------------
SELECT AVG(items.price) FROM items
INNER JOIN purchases ON items.id = purchases.item_id;