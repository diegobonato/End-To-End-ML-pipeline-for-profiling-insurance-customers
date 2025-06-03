# How to set up the dataware house

- Run docker compose up on the directory containing the compose.yml file. It will launch a container with psql in it. 
- Run docker exec -i <container_id> psql -U postgres -d postgres < policyML/medallion_datawarehouse.sql  This will create the database and the medallion structure schemas. 
- You can check that the db now exists by entering the psql shell:  docker exec -it <container_id> psql -U postgres -d postgres and use the command \l to list all available databases. 
!!! Mind the difference between docker exec -i and docker exec -it !!!
- Now create the first table inside the bronze schema. Run docker exec -i <container_id> psql -U postgres -d postgres < policyML/bronze/bronze_create_table.sql
- Last, fill in the data with the python script bronze.py: python bronze.py (outside the docker container, which should still be running) 
