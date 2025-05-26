-- Creating bronze and silver schemas in the DataWarehouse database 
-- Following this video: https://www.youtube.com/watch?v=SSKVgrwhzus&t=85986s
-- bronze will have raw data, silver will have cleansed data.

CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA silver;
