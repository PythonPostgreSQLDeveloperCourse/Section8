----------------------------------------------------
-- select from items where price is greater than the result
-- of the nested query which is the average item price
-- 
-- name         | id | price
-- -------------|----|-------
-- 'Screen'     |5   |'275.50'
-- 'DSLR Camera'|9   |'400.00'
-- 
----------------------------------------------------
SELECT * FROM items WHERE price >
(SELECT AVG(items.price) FROM items);