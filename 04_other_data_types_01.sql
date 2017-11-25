----------------------------------------------------
-- Create an mood field name that can only hold values
-- 'extremely unhappy', 'unhappy', 'ok', 'happy', 'extremely happy'
----------------------------------------------------
CREATE TYPE mood AS ENUM('extremely unhappy', 'unhappy', 'ok', 'happy', 'extremely happy');