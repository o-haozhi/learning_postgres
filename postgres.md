# psql

psql -h hostname -p 5432 -U username -d database_name

# postgres (in psql)

- \l - Lists all Databases
- \c  \<database_name\> - connect to db
- CREATE DATABASE \<name\> - create a db
- DROP DATABASE \<name> - delete a db
- CREATE TABLE \<name> (args) - create a table
    - Example: 
        
        ``` 
        CREATE TABLE person (        
            id BIGSERIAL NOT NULL PRIMARY KEY,
            first_name VARCHAR(50) NOT NULL,
            last_name VARCHAR(50) NOT NULL,
            gender VARCHAR(7) NOT NULL,
            date_of_birth DATE NOT NULL,
            email VARCHAR(150)
        );
        ```

- DROP TABLE \<name> - delete a table
- \d - lists relations
- \d \<name> - view more info about the table
- \dt - show only tables 
- INSERT INTO \<name> (args) VALUES (args) - insert record into a table
    - Examples: 
        ```
        INSERT INTO person (first_name, last_name, gender, date_of_birth) 
        VALUES ('Anne', 'Smith', 'FEMALE', date '1988-01-09');
        ```

        ```
        INSERT INTO person (first_name, last_name, gender, date_of_birth, email) 
        VALUES ('Jake', 'Jones', 'MALE', date '1990-12-31', 'jake@gmail.com');
        ```
<br>

> Generating Random Data: https://www.mockaroo.com/

<br>

- \i \<path to file> - run an sql file
- If running in docker container:
    ```  
    docker cp /path/to/local/file.sql <container_name>:/tmp/file.sql
    docker exec -it <container_name> psql -U <username> -d <database_name> -f /tmp/file.sql
    docker exec -it <container_name> rm /tmp/file.sql
    ```
- SELECT \<col> FROM \<table>;
- SELECT \<col> FROM \<table> ORDER BY \<col> (ASC/DESC);
- SELECT DISTINCT \<col> FROM \<table> ORDER BY \<col> (ASC/DESC); - Remove Duplicates
- Clause: WHERE (condition); - add this clause to specify conditions
    - Example:
        ```
            SELECT * FROM person WHERE gender = 'Male' AND (country_of_birth = 'Poland' OR country_of_birth = 'China');
        ```
- Comparison Operators: 
    - equals, = 
    - less than, <
    - less than or equals, <=
    - more than, >
    - more than or equals, >=
    - not equals, <>

- Clause: LIMIT (number) - limit number of results
- Clause: OFFSET (number) - set an offset
- Clause: FETCH FIRST (number) ROW ONLY - alternative to LIMIT (SQL standard)
- KEYWORD: IN (values)
    - Example:
        
        ```
        SELECT * FROM person
        WHERE country_of_birth 
        IN ('China', 'Brazil', 'France');
        ```
- KEYWORD: BETWEEN (values)
    - Example:
        
        ```
        SELECT * FROM person
        WHERE date_of_birth 
        BETWEEN DATE '2000-01-01' AND '2026-01-01';
        ```
- KEYWORD: LIKE/ILIKE (case-sensitive/not case-sensitive)
    - Comparitors:
        - % - any strings
        - _ - any one char
    - Example:
        
        ```
        SELECT * FROM person
        WHERE email 
        LIKE '______@%.com';
        ```
- FUNCTION: COUNT(arg) - Count number of entries 
- KEYWORD: GROUP BY
    - Example:

    ```
    SELECT country_of_birth, COUNT(*) FROM person
    GROUP BY country_of_birth
    ORDER BY country_of_birth;
    ```
- KEYWORD: HAVING (function/condition) (works with the GROUP BY keyword)
    - Example:

    ```
    SELECT country_of_birth, COUNT(*) FROM person
    GROUP BY country_of_birth
    HAVING COUNT(*) > 5
    ORDER BY country_of_birth;
    ```