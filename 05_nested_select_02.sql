----------------------------------------------------
-- figure out how much above or below the average price
----------------------------------------------------
SELECT items.name, items.price - (
	SELECT AVG(items.price) FROM items)
FROM items;