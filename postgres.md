# psql

psql -h hostname -p 5432 -U username -d database_name

# postgres (in psql)

- \l - Lists all Databases
- \c <database_name> - connect to db
- CREATE DATABASE <name> - create a db
- DROP DATABASE <name> - delete a db
- CREATE TABLE <name> (args) - create a table
    - Example: CREATE TABLE person (
                  id BIGSERIAL NOT NULL PRIMARY KEY,
                  first_name VARCHAR(50) NOT NULL,
                  last_name VARCHAR(50) NOT NULL,
                  gender VARCHAR(7) NOT NULL,
                  date_of_birth DATE NOT NULL,
                  email VARCHAR(150)
               ); 
- DROP TABLE <name> - delete a table
- \d - lists relations
- \d <name> - view more info about the table
