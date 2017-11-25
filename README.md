# Views and What They Are Used For

- result of a query
- not quite that simple
- other things you can do with views
- you can interact with views much like a camera looking at a query

```
SELECT customers.first_name, customers.last_name, SUM(items.price) FROM customers
INNER JOIN purchases ON customers.id = purchases.customer_id
INNER JOIN items ON purchases.item_id = items.id
GROUP BY customers.id;
```

- NOTES on this query
	+ once `GROUP BY` is used, granularity and accessibility of rows of purchases and items gets lost
	+ we cannot select anything unless it is part of the customers table
	+ SUM is acting on items linked in this table but before it is grouped
- We can save result as a view
	+ just add in the beginning `CREATE VIEW total_revenue_per_customer AS`

```
CREATE VIEW total_revenue_per_customer AS
SELECT customers.first_name, customers.last_name, SUM(items.price) FROM customers
INNER JOIN purchases ON customers.id = purchases.customer_id
INNER JOIN items ON purchases.item_id = items.id
GROUP BY customers.id;
```

- then we can access the content of the query by selecting the view like so
- much simpler

`SELECT * FROM total_revenue_per_customer`

`DROP VIEW total_revenue_per_customer`

- add in the id

```
CREATE VIEW total_revenue_per_customer AS
SELECT customers.id, customers.first_name, customers.last_name, SUM(items.price) FROM customers
INNER JOIN purchases ON customers.id = purchases.customer_id
INNER JOIN items ON purchases.item_id = items.id
GROUP BY customers.id;
```

`SELECT * FROM total_revenue_per_customer`

- views are constantly up to date with our data
- if a new purchase is added to purchases, if the view is executed we can see the values are up to date

```
INSERT INTO purchases
VALUES (11, 6, 5)
```

`SELECT * FROM total_revenue_per_customer`

- select *awesome* customers

`SELECT * FROM total_revenue_per_customer WHERE sum > 150`

- create *another* `VIEW` from this `VIEW`

```
CREATE VIEW awesome_customers AS
SELECT * FROM total_revenue_per_customer WHERE sum > 150;
```

```
SELECT * FROM awesome_customers
ORDER BY sum DESC
```

- behaves exactly like a table
- data is result of other queries
- nested queries

- insert into a view
- cannot be done if a view has a `GROUP BY` clause

## Inserting into Views

```
CREATE VIEW expensive_items AS
SELECT * FROM items WHERE price > 100;
```

```
INSERT INTO expensive_items (id, name, price)
VALUES(9, 'DSLR Camera', 400.00)
```

- but that allows us to insert any item no matter the price into `expensive_items`

`DROP VIEW expensive_items`

```
CREATE VIEW expensive_items AS
SELECT * FROM items WHERE price > 100
WITH LOCAL CHECK OPTION;
```

- each part of the `WHERE` is being checked when doing an update on the `VIEW`
- postgres only code

```
ERROR:  new row violates check option for view "expensive_items"
DETAIL:  Failing row contains (Pencil, 11, 2.00).
SQL state: 44000
```

- when creating a view of another view there are more options
- recreate the `expensive_items` view without `LOCAL CHECK OPTION`
- create a new `non_luxury_items` view with `LOCAL CHECK OPTION` enabled

```
CREATE VIEW non_luxury_items AS
SELECT * FROM expensive_items WHERE price < 10000
WITH LOCAL CHECK OPTION
```

```
INSERT INTO non_luxury_items(id, name, price)
VALUES (12, 'Pencil', 2.00)
```

- will Pencil get added? A: yes
- `LOCAL CHECK`, "local to the view we are using"

`DROP VIEW non_luxury_items`

## Cascaded Check Option

```
CREATE VIEW non_luxury_items AS
SELECT * FROM expensive_items WHERE price < 10000
WITH CASCADED CHECK OPTION
```

- with `LOCAL CHECK` set on `expensive_items` and `CASCADING CHECK` set on `non_luxury_items` if we try to add `Pencil` with a value of 2.0 to `non_luxury_items` we receive an error:

```
ERROR:  new row violates check option for view "expensive_items"
DETAIL:  Failing row contains (Pencil, 11, 2.00).
SQL state: 44000
```

- `CASCADED or LOCAL` - "validators"


# Dates in SQL: An Old Problem


## The Problem

- dates can be formatted in many different ways
- can be ambiguous
- timezones are attached to them
- which timezone for the user
- daylight savings

## Recommendations

- naive datetime
- store date without timezone information in the database
- retrieve timezone information with the database query or in python app


## Data Types

- timestamp
- date
- time
- interval

```sql
----------------------------------------------------
-- ISO 8601
-- Year-Month-Day Hours:Minutes:Seconds:Milliseconds
----------------------------------------------------
SELECT timestamp '2005-10-10 05:16:45';
```

- "postgres give me timestamp (formatted in ISO 8601) on Oct 10th 2005"
- least ambiguous dates


## Make Timestamps More Readable

```sql
---------------------------------------
-- ISO 8601 to Human Readable
-- Day-Month-Year Hours:Minutes:Seconds
---------------------------------------
SELECT TO_CHAR(NOW(), 'DD-MM-YYYY HH:MI:SS');
```

```sql
---------------------------------------
-- ISO 8601 to Human Readable
-- FMDay = fill mode day (removes space padding)
-- DDth = insert the appropriate ending (th, nd, st)
-- Day-Month-Year Hours:Minutes:Seconds
-- Sunday, 19th November, 2017 06:04:06
---------------------------------------
SELECT TO_CHAR(NOW(), 'FMDay, DDth FMMonth, YYYY HH:MI:SS');
```

```sql
---------------------------------------
-- Human Readable to ISO 8601
-- 2017-11-19 06:04:06-05
-- -05 from UTC (Eastern Time)
---------------------------------------
SELECT TO_TIMESTAMP('Sunday, 19th November, 2017 06:04:06', 'FMDay, DDth FMMonth, YYYY HH:MI:SS');
```

```sql
---------------------------------------
-- Human Readable to ISO 8601
-- 2015-10-10 01:02:03-04
-- -04 from UTC (Eastern Daylight Savings Time)
-- Daylight Savings Time ended Nov 5, 2017 at 2:00 am
---------------------------------------
SELECT TO_TIMESTAMP('2015-10-10 01:02:03', 'YYYY-MM-DD HH:MI:SS');
```




# Built-in Functions and the HAVING construct

## COUNT & SUM

- `SUM`: get the total revenue generated per customer
- `COUNT`: get total number of purchases for each customer

```sql
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
```

- `AVG`: get the average

```sql
----------------------------------------------------
-- Average price of all items in the inventory
-- '112.6842857142857143'
----------------------------------------------------
SELECT AVG(items.price) FROM items;
```

```sql
----------------------------------------------------
-- Average price of all items purchased
-- '72.2587500000000000'
----------------------------------------------------
SELECT AVG(items.price) FROM items
INNER JOIN purchases ON items.id = purchases.item_id;
```

- `MAX`: get the max value without having to do a `GROUP BY` or a `LIMIT`
- `MIN`: the opposite of `MAX`

```sql
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
```

```sql
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
```


- `HAVING`: filter after the aggregation has taken place

```sql
----------------------------------------------------
-- Get customer purchase count if number of purchases is greater than 3
-- `GROUP BY` = aggregation clause
-- `WHERE` cannot be used after aggregation
-- `HAVING` replaces the `WHERE` to make it work
-- purchase_count column doesn't exist yet so we have to use `COUNT(purchases.id)` in the `HAVING` statement
--
-- first_name | last_name | purchase_count
-- -----------|-----------|---------------
-- 'Michael'  | 'Adam'    | '4'
-- 
-- `COUNT` is another aggregating function used after `HAVING`
----------------------------------------------------
SELECT customers.first_name, customers.last_name,
	COUNT(purchases.id) AS purchase_count
FROM customers
INNER JOIN purchases ON customers.id = purchases.customer_id
GROUP BY customers.id
HAVING COUNT(purchases.id) > 3;
```


# Other Data Types

## Image and Binary Data

- `BYTEA`: bytes, anything you want
- images composed of pixel
- each pixel information
	+ take all that information and put into a BYTEA
	+ up to 1 GB in size
	+ usually recommended to store path in SQL

- `ENUM`
	+ a set of strings
	+ limit what type of data you can put into a row
	+ age, color are examples
- `CREATE TYPE mood as ENUM('')`
	+ inside `ENUM()` we put the limits of what can be used as values for the field
- Important to know `ENUM`s are ordered
	+ filtering by enum is possible


```sql
----------------------------------------------------
-- Create an mood field name that can only hold values
-- 'extremely unhappy', 'unhappy', 'ok', 'happy', 'extremely happy'
----------------------------------------------------
CREATE TYPE mood AS ENUM('extremely unhappy', 'unhappy', 'ok', 'happy', 'extremely happy');

----------------------------------------------------
-- Create a table of students
----------------------------------------------------
CREATE TABLE students (
name character varying(255),
current_mood mood
);

----------------------------------------------------
-- Try to input a student with an invalid value for mood
-- 
-- ERROR:  invalid input value for enum mood: "hapy"
-- LINE 1: INSERT INTO students VALUES('Moe', 'hapy')
----------------------------------------------------
INSERT INTO students VALUES('Moe', 'hapy');

----------------------------------------------------
-- Put in some valid data
----------------------------------------------------
INSERT INTO students VALUES('Moe', 'happy');
INSERT INTO students VALUES('Larry', 'happy');
INSERT INTO students VALUES('Shemp', 'extremely unhappy');
INSERT INTO students VALUES('Curly', 'extremely happy');
INSERT INTO students VALUES('Joe B', 'happy');
INSERT INTO students VALUES('Joe D', 'unhappy');

----------------------------------------------------
-- Filter by current_mood greater than 'ok'
--
-- name    | current_mood
-- --------|-------------
-- 'Moe'   | 'happy'
-- 'Larry' | 'happy'
-- 'Curly' | 'extremely happy'
-- 'Joe B' | 'happy'
--
----------------------------------------------------
SELECT * FROM students WHERE current_mood > 'ok'

```

## JSON

- Why do I care?
- databases are rigidly structured
- JSON is less structured
- more flexible
- but slower
- nosql No Relational Database is specialized in storing JSON formatted strings

# Nested `SELECT` Statements for Complex Queries

- Sub-Queries
- Use them in `SELECT` clauses or `WHERE` clauses
- What items do we own that are above the average price of our items?
	+ May want to know this information to figure out whether those items would sell less
- Used where `HAVING` is not able to be used
- The statement could look something like this but doesn't work
	- `SELECT * FROM items WHERE price > AVG(price);`
	- `HAVING` is not useful because we are not using a `GROUP BY`
- Find the deviation from the average
- Generate a View for luxury items that also tells us the difference from the average luxury item

```sql
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
```

```sql
----------------------------------------------------
-- figure out how much above or below the average price
----------------------------------------------------
SELECT items.name, items.price - (
	SELECT AVG(items.price) FROM items)
FROM items;
```

```sql
----------------------------------------------------
-- Selecting all of the columns from items and items price, selecting the price twice, but the second time subtracting the average price of luxury items, valued greater than 100.
-- Create a VIEW
----------------------------------------------------
CREATE VIEW expensive_items_diff AS 
SELECT *, items.price -
(SELECT AVG(items.price) FROM items WHERE price > 100) AS "average_diff"
FROM items WHERE price > 100;

----------------------------------------------------
-- Select items from the view
----------------------------------------------------
SELECT * FROM expensive_items_diff
```
# Serial Type

- auto incrementing fields takes a few steps
- this is a shorcut
- auto incrmenting id field

```sql
----------------------------------------------------
-- `SERIAL` is an auto-incrementing sequence beginning with 1
-- `text` has no upper limit like `character varying(255)`
-- `SERIAL` does not ensure numbers are unique, for that 
-- we use `PRIMARY KEY` or `UNIQUE` in conjunction with `SERIAL`
----------------------------------------------------
CREATE TABLE test(
	id SERIAL PRIMARY KEY,
	name text
);

INSERT INTO test(name) VALUES ('Jose');

SELECT * FROM test;
```
