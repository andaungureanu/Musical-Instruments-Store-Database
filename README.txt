1. Have a local database
2. Run the contents of create_and_populate_database.sql
3. Create the procedures by running the contents of:
	- p_get_favorite_instruments.sql
	- p_get_favorite_manufacturers.sql
	- p_get_most_expensive_orders.sql
4. Open main.py in VSCode
5. Download Instant Client (see documentation and other specific steps on the 
internet) and add the path to the init_oracle_client function (line 88) since 
mine might not be the same as yours
6. Create the OracleConnection object (line 89) using your local database
properties: username, password, host, port, sid (replace mine)
7. Run main.py and see the graphs
8. In order to clean the database, run the contents of clean_database.sql