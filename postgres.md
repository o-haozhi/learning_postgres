# psql

psql -h hostname -p 5432 -U username -d database_name

# side note
- Views can be helpful when working in across teams.
- Views are virtual tables:
    - Example Creation:

        ```
        CREATE VIEW view_name AS
        SELECT column1, column2
        FROM table_name
        WHERE condition;
        ```
    - Example Query:
        ```
        SELECT * FROM view_name;
        ```

    - Example Update:
    
        ```
        CREATE OR REPLACE VIEW active_sales_staff AS
        SELECT id, name, email, hire_date  
        FROM employees
        WHERE department = 'Sales' AND status = 'active';
        ```
        - Note: PostgreSQL allows you to replace a view this way only if you keep the existing columns (same name and data type) and simply append new columns to the end. If you want to change the structure completely, you must ```DROP VIEW view_name;``` first. 

# postgres (in psql)

- Data Types: https://www.postgresql.org/docs/current/datatype.html 

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
- FUNCTION: MAX(col)
    - Example:

        ```
        SELECT MAX(price) FROM car;
        ```
- FUNCTION: MIN(col)
    - Example:

        ```
        SELECT MIN(price) FROM car;
        ```
- FUNCTION: AVG(col)
    - Example:

        ```
        SELECT AVG(price) FROM car;
        ```
- FUNCION: ROUND(value, (decimal))
    - Example:

        ```
        SELECT ROUND(AVG(price)) FROM car;
        ```

        ```
        SELECT make, model, ROUND(MIN(price), 2) FROM car 
        GROUP BY make, model;
        ```
- FUNCTION: SUM(arg)
    - Example:

        ```
        SELECT SUM(price) FROM car;
        ```

        ```
        SELECT make, SUM(price) FROM car GROUP BY make;
        ```

- Basic Arithematic Operations:
    - Addition ( + )
    - Subtraction ( - )
    - Multiplication ( * )
    - Division ( / )
    - Power ( ^ )
    - Factorial ( ! )
    - Modulo ( % )

    - Example: 
        ```
        SELECT *, ROUND(price*0.1, 2), ROUND(price - (price*0.1), 2) FROM car;
        ```

- Alias (AS):
    - Example: 
        
        ```
        SELECT id, make, model, price AS original_price, ROUND(price*0.1, 2) AS ten_percent, ROUND(price - (price*0.1), 2) AS discounted_price FROM car;
        ```

- KEYWORD: COALESCE(value) - returns first non-null value
    - Example: 
        
        ```
        SELECT COALESCEC(null, null, 1, 10);
        ```

        ```
        SELECT COALESCE(email, 'Email not provided') FROM person;
        ```

- Tackling Division by Zero/Errors: NULLIF
    - NULLIF(value1, value2) returns null if value1 == value2
    - Example:

        ```
        SELECT COALESCE(10/NULLIF(0,0), 0); 
        -- 10/null = null not an error
        -- 10/0 is an error
        -- Above query prevents division by zero error
        ```

- Time and Date:
    - NOW() - gives current timestamp
        - NOW()::DATE - cast to a DATE
        - NOW()::TIME - cast to TIME
    - Example:
        
        ```
        SELECT NOW();
        SELECT NOW()::DATE;
        SELECT NOW()::TIME;
        ```
    - Adding and Subtracting TIME and DATE is possible:

        ```
        SELECT NOW() - INTERVAL '1 YEAR';
        ```

        ```
        SELECT NOW() - INTERVAL '10 YEARS';
        ```

        ```
        SELECT NOW() - INTERVAL '10 MONTHS';
        ```

        ```
        SELECT NOW() - INTERVAL '10 DAYS';
        ```

        ```
        SELECT NOW() + INTERVAL '10 MONTHS';
        ```

        ```
        SELECT NOW() + INTERVAL '10 DAYS';
        ```
    
    - Extracting Fields from Timestamps: EXTRACT
        
        ```
        SELECT EXTRACT(YEAR FROM NOW());
        ```

        ```
        SELECT EXTRACT(MONTH FROM NOW());
        ```

        ```
        SELECT EXTRACT(DAY FROM NOW());
        ```

        ```
        SELECT EXTRACT(DOW FROM NOW()); -- DAY OF WEEK (Sunday is 0)
        ```

        ```
        SELECT EXTRACT(CENTURY FROM NOW());
        ```