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