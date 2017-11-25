---------------------------------------
-- Human Readable to ISO 8601
-- 2015-10-10 01:02:03-04
-- -04 from UTC (Eastern Daylight Savings Time)
-- Daylight Savings Time ended Nov 5, 2017 at 2:00 am
---------------------------------------
SELECT TO_TIMESTAMP('2015-10-10 01:02:03', 'YYYY-MM-DD HH:MI:SS');