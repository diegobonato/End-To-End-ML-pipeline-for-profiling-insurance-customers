/*
Script to Create Database and Schemas - run this script in the docker container where the server is running
in the docker container terminal:

docker exec -i <container_id> psql -U postgres -d postgres < policyML/medallion_datawarehouse.sql 
# The -i is fundamental to allow input from the terminal inside the container
--
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
Reference: https://www.youtube.com/watch?v=SSKVgrwhzus&t=85986s
-- bronze will have raw data, silver will have cleansed data, gold will have aggregated data (business layer)
*/


-- Terminate any existing connections to 'datawarehouse'
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'datawarehouse'
AND pid <> pg_backend_pid();

-- Drop the database if it exists
DROP DATABASE IF EXISTS datawarehouse;

CREATE DATABASE datawarehouse;

--\connect datawarehouse

