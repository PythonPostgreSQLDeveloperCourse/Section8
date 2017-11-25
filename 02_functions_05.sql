----------------------------------------------------
-- Get customer purchase count if number of purchases is greater than 3
-- `GROUP BY` = aggregation clause
-- `WHERE` cannot be used after aggregation
-- `HAVING` replaces the `WHERE` to make it work
-- purchase_count column doesn't exist yet so we have to use `COUNT(purchases.id)` in the `HAVING` statement
----------------------------------------------------
SELECT customers.first_name, customers.last_name,
	COUNT(purchases.id) AS purchase_count
FROM customers
INNER JOIN purchases ON customers.id = purchases.customer_id
GROUP BY customers.id
HAVING COUNT(purchases.id) > 3;