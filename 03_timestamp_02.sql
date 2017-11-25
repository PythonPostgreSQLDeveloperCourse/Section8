---------------------------------------
-- ISO 8601 to Human Readable
-- FMDay = fill mode day (removes space padding)
-- DDth = insert the appropriate ending (th, nd, st)
-- Day-Month-Year Hours:Minutes:Seconds
---------------------------------------
SELECT TO_CHAR(NOW(), 'FMDay, DDth FMMonth, YYYY HH:MI:SS');