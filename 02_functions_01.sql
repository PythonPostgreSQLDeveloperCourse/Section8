----------------------------------------------------
-- combine customers and purchases when customer id exists in  both
-- count happens before group
-- group based on customer id removes duplicate entries per user
----------------------------------------------------
SELECT customers.first_name, customers.last_name,
	COUNT(purchases.id) AS purchase_count
FROM customers
INNER JOIN purchases ON customers.id = purchases.customer_id
GROUP BY customers.id;