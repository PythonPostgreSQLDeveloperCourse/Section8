----------------------------------------------------
-- Selecting all of the columns from items and items price, selecting the price twice, but the second time subtracting the average price of luxury items, valued greater than 100.
-- Create a VIEW
----------------------------------------------------
CREATE VIEW expensive_items_diff AS 
SELECT *, items.price -
(SELECT AVG(items.price) FROM items WHERE price > 100) AS "average_diff"
FROM items WHERE price > 100;