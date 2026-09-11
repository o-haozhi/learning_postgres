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

- Prevent SQL injection by using Parameterized Queries and prepared statements:
    - Do not concatenate user input into your SQL strings
    - Validate and Sanitize Inputs
    - Escape Dynamic Identifiers
    - Apply Least Privilege

# postgres (in psql)

- Data Types: https://www.postgresql.org/docs/current/datatype.html 
- Additional Info: https://neon.com/postgresql/tutorial

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

- FUNCTION: AGE(to_date, from_date)
    - Example:
        
        ```
        SELECT *, AGE(NOW(), date_of_birth) AS age FROM person;
        ```

- CONSTRAINT: PRIMARY KEY
    - Uniquely Identifies a record in a table
    - If a PRIMARY KEY of a certain value already exists in the table, a second record with the same PRIMARY KEY value cannot be inserted.
    - Removing PRIMARY KEY from a table:
        
        ```
        ALTER TABLE <table_name> DROP CONSTRAINT <name_pkey>;
        ``` 
    
    - Adding PRIMARY KEY constraint (only works if all entrys are unique in target col): 

        ```
        ALTER TABLE <table_name> ADD PRIMARY KEY (values/cols);
        ```

- CONSTRAINT: UNIQUE
    ```
    ALTER TABLE <table_name> ADD CONSTRAINT <constraint_name> UNIQUE (target_col);
    ```
    ```
    ALTER TABLE <table_name> ADD UNIQUE (target_col);
    ```
    - Only works when no entry values are duplicate in the target col
    - However, duplicate NULL is ok.
    - Creates an index

- DELETE - remove entry from table
    ```
    DELETE FROM <table_name> WHERE <condition>;
    ```

- CONSTRAINT: CHECK
    ```
    ALTER TABLE <table_name> ADD CONSTRAINT <constraint_name> CHECK (condition);
    ```
    - constraint can only be added if the current table doesn't violate the constraint
    - Example:
        ```
        ALTER TABLE person ADD CONSTRAINT gender_constraint CHECK (gender IN ('Male', 'Female', 'Bigender', 'Agender', 'Genderqueer', 'Genderfluid', 'Polygender', 'Non-binary'));
        ```
    - Adding CHECK in CREATE TABLE:

        ```
        create table car (
            car_uid UUID NOT NULL PRIMARY KEY,
            make VARCHAR(50) NOT NULL,
            model VARCHAR(50) NOT NULL,
            price DECIMAL(19,2) NOT NULL CHECK (price > 0)
        );
        ``` 
- Updating Records: UPDATE
    ```
    UPDATE <table_name> SET col_name = value, ... , col_name = value WHERE <condition>;
    ```

- Dealing with UNIQUE/PRIMARY KEY Errors/Exceptions (ON CONFLICT):
    - ON CONFLICT (unique_col) DO NOTHING
        ```
        INSERT INTO <table_name> (cols)
        VALUES (values)
        ON CONFLICT (unique_col_name) DO NOTHING; 
        ```

    - ON CONFLICT (unique_col) DO UPDATE SET \<col = value> (UPSERT)
        ```
        INSERT INTO <table_name> (cols)
        VALUES (values)
        ON CONFLICT (unique_col_name) DO UPDATE SET <col = value>; 
        ```
        
        - KEYWORD: EXCLUDED
            - Use this KEYWORD to reference values in the conflicting entry

        - Examples:
            ```
            INSERT INTO person (id, first_name, last_name, gender, date_of_birth, country_of_birth) 
            VALUES (1, 'Minne', 'Hum','Female', DATE '2026-07-17', 'Papua New Guina') 
            ON CONFLICT (id) DO UPDATE SET email = 'abc@xyz.com';
            ```
            ```
            INSERT INTO person (id, first_name, last_name, email, gender, date_of_birth, country_of_birth) 
            VALUES (1, 'Moon', 'Ham', 'xyz@abc.com', 'Female', DATE '2026-07-17', 'Papua New Guina') 
            ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email, first_name = EXCLUDED.first_name, last_name = EXCLUDED.last_name;
            ```

- RELATIONSHIPS: FOREIGN KEYS & JOINS
    - FOREIGN KEY: A col that references a PRIMARY KEY in another TABLE
    - SETTING UP A RELATIONSHIP:
        - Example:
            
            ```
            create table car (
                id BIGSERIAL NOT NULL PRIMARY KEY,
                make VARCHAR(50) NOT NULL,
                model VARCHAR(50) NOT NULL,
                price DECIMAL(19,2) NOT NULL
            );

            create table person (
                id BIGSERIAL NOT NULL PRIMARY KEY,
                first_name VARCHAR(50) NOT NULL,
                last_name VARCHAR(50) NOT NULL,
                email VARCHAR(150),
                gender VARCHAR(12) NOT NULL,
                date_of_birth DATE NOT NULL,
                country_of_birth VARCHAR(50) NOT NULL,
                car_id BIGINT REFERENCES car (id),
                UNIQUE(car_id)
            ); 
            ```
    - ADDING A RELATIONSHIP:
        - When adding a relation, the key referred must exist.
        - Example:
            
            ```
            UPDATE person SET car_id = 2 WHERE id = 1;
            ```

- COMBINING TABLES: 
    - INNER JOINS
        - Joins 2 tables with a PRIMARY-FOREIGN KEY pair
        - Only Joins the entries where pairs exist
        - Example:

            ```
            SELECT * FROM person
            JOIN car ON person.car_id = car.id;
            ```
    - LEFT JOINS
        - Joins 2 tables and returns all records of left table even if there is no matching key pair
        - Example:

            ```
            SELECT * FROM person
            LEFT JOIN car ON car.id = person.car_id;
            ```
            ```
            SELECT * FROM person
            LEFT JOIN car ON car.id = person.car_id
            WHERE car.* IS NULL;
            ```

- Handling Deletion of Records with referenced PRIMARY KEY:
    - An entry with a PRIMARY KEY cannot be deleted if it is reference as a FOREIGN KEY
    - To delete a record with a referenced PRIMARY KEY:
        1. Delete the referencing record
        2. Update the referencing record to a different foreign key/null

- Creating CSVs with Postgres
    - In psql:
        ```
        \copy (SELECT <col> FROM <table>) TO 'path/to/file.csv' DELIMITER ',' CSV HEADER;
        ```
    - or from terminal:

        ```
        psql -h 127.0.0.1 -p 5432 -U your_db_user -d your_db_name -c "\copy table_name TO 'output.csv' CSV HEADER"
        ```
    
- SERIAL & SEQUENCES
    - When using types like BIGSERIAL, a sequence is generated
    - You can view the sequence via:

        ```
        SELECT * FROM <seq_name>;
        ```
    - 3 Values in the sequence: 
        - last_value - last entry added
        - log_cnt - number of times evoked
        - is_called 
    - Looking at the property of a TABLE, for the col that the sequence applies, you will find:  

        ```
        nextval('person_id_seq'::regclass)
        ```
    - As it is a function, you can view this:

        ```
        SELECT nextval('person_id_seq'::regclass);
        ```
    - However, note that each time nextval is evoked, it increments the sequeence.
    - To reset a sequence:
        
        ```
        ALTER SEQUENCE <seq_name> RESTART WITH <number>;
        ```
        This sets the last_value to the given number, log_cnt to 0 and is_called to f.

- EXTENSIONS
    - Basically functions that can add additional ability to the db
    - To view available extensions
        
        ```
        SELECT * FROM pg_available_extensions;
        ```

- EXTENSION: UUID (Universally Unique Identifiers)
    - To add the extension:
        
        ```
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
        ```
    - Use ```\df``` to list functions in psql 
    - one function in the uuid-ossp extension is ```uuid_generate_v4```:
    
        ```
        SELECT uuid_generate_v4();
        ```
    - Example of using UUID as PRIMARY KEY:
        
        ```
        create table car (
            car_uid UUID NOT NULL PRIMARY KEY,
            make VARCHAR(50) NOT NULL,
            model VARCHAR(50) NOT NULL,
            price DECIMAL(19,2) NOT NULL CHECK (price > 0)
        );

        create table person (
            person_uid UUID NOT NULL PRIMARY KEY,
            first_name VARCHAR(50) NOT NULL,
            last_name VARCHAR(50) NOT NULL,
            email VARCHAR(150),
            gender VARCHAR(12) NOT NULL,
            date_of_birth DATE NOT NULL,
            country_of_birth VARCHAR(50) NOT NULL,
            car_uid UUID REFERENCES car (car_uid),
            UNIQUE(car_uid),
            UNIQUE(email)
        );
        ```

- KEYWORD: USING

    - When 2 TABLES share PRIMARY-FOREIGN KEY pair with the same col name, use this keyword to eliminate duplicating the col:
        
        ```
        SELECT * FROM <table>
        JOIN <table> USING (col);
        ```
    - Consider using NATURAL JOIN too.

# YET TO COVER: (As referenced from https://neon.com/postgresql/tutorial)
- Set Operations
    - Union – combine result sets of multiple queries into a single result set.
    - Intersect – combine the result sets of two or more queries and return a single result set containing rows that appear in both result sets.
    - Except – return the rows from the first query that do not appear in the output of the second query.

- Grouping sets, Cubes, and Rollups
    - Grouping Sets  – generate multiple grouping sets in reporting.
    - Cube – define multiple grouping sets that include all possible combinations of dimensions.
    - Rollup – generate reports that contain totals and subtotals.

- Subquery
    - Subquery – write a query nested inside another query.
    - Correlated Subquery – show you how to use a correlated subquery to perform a query that depends on the values of the current row being processed.
    - ANY  – retrieve data by comparing a value with a set of values returned by a subquery.
    - ALL – query data by comparing a value with a list of values returned by a subquery.
    - EXISTS  – check for the existence of rows returned by a subquery.

- Common Table Expressions
    - PostgreSQL CTE – introduce you to PostgreSQL common table expressions or CTEs.
    - Recursive query using CTEs – discuss the recursive query and learn how to apply it in various contexts.

- Transactions
    - PostgreSQL Transactions – show you how to handle transactions in PostgreSQL using BEGIN, COMMIT, and ROLLBACK statements.

- Import Data
    - Import CSV file into Table – show you how to import CSV file into a table.

- Managing Tables
    - Data types – cover the most commonly used PostgreSQL data types.
    - Select Into & Create table as– shows you how to create a new table from the result set of a query.
    - Sequences – introduce you to sequences and describe how to use a sequence to generate a sequence of numbers.
    - Identity column – show you how to use the identity column.
    - Rename table – change the name of the table to a new one.
    - Add column – show you how to add one or more columns to an existing table.
    - Drop column – demonstrate how to drop a column of a table.
    - Change column data type – show you how to change a column’s data.
    - Rename column – illustrate how to rename one or more table columns.
    - Truncate table – remove all data in a large table quickly and efficiently.
    - Temporary table – show you how to use the temporary table.
    - Copy a table – show you how to copy a table to a new one.

- PostgreSQL Constraints
    - DELETE CASCADE – show you how to automatically delete rows in child tables when the corresponding rows in the parent table are deleted.
    - DEFAULT constraint – specify a default value for a column using the DEFAULT constraint.

- PostgreSQL Data Types in Depth
    - Boolean – store TRUE and FALSEvalues with the Boolean data type.
    - CHAR, VARCHAR, and TEXT – learn how to use various character types including CHAR, VARCHAR, and TEXT.
    - NUMERIC – show you how to use NUMERIC type to store values that precision is required.
    - DOUBLE PRECISION – learn to store inexact, variable-precision numbers in the database. The DOUBLE PRECISION type is also known as the FLOAT type.
    - REAL – guide you on how to use single-precision floating-point numbers in the database.
    - Integer – introduce you to various integer types in PostgreSQL including SMALLINT, INT and BIGINT.
    - DATE  – introduce the DATE data type for storing date values.
    - Timestamp – understand timestamp data types quickly.
    - Interval – show you how to use interval data type to handle a period effectively.
    - TIME – use the TIME datatype to manage the time of day values.
    - UUID – guide you on how to use UUID datatype and how to generate UUID values using supplied modules.
    - Array – show you how to work with arrays and introduce you to some handy functions for array manipulation.
    - hstore – introduce you to the hstore data type, a set of key/value pairs stored in a single value in PostgreSQL.
    - JSON – illustrate how to work with JSON data type and use some of the most important JSON operators and functions.
    - User-defined data types – show you how to use the CREATE DOMAIN and CREATE TYPE statements to create user-defined data types.
    - Enum – learn how to create an enum type that defines a list of fixed values for a column.
    - XML – show you how to store XML documents in the database using the XML data type.
    - BYTEA – learn how to store binary strings in the database.
    - Composite Types – show you how to define a composite type that consists of multiple fields.

- Conditional Expressions & Operators
    - CASE – show you how to form conditional queries with CASE expression.
    - COALESCE – return the first non-null argument. You can use it to substitute NULL by a default value.
    - NULLIF – return NULL if the first argument equals the second one.
    - CAST – convert from one data type into another e.g., from a string into an integer, from a string into a date.

- PostgreSQL Utilities
    - psql commands – show you the most common psql commands that help you interact with psql faster and more effectively.

- PostgreSQL Recipes
    - How to compare two tables – describe how to compare data in two tables in a database.
    - How to delete duplicate rows in PostgreSQL – show you various ways to delete duplicate rows from a table.
    - How to generate a random number in a range  – illustrate how to generate a random number in a specific range.
    - EXPLAIN statement– guide you on how to use the EXPLAIN statement to return the execution plan of a query.
    - PostgreSQL vs. MySQL – compare PostgreSQL with MySQL in terms of functionalities.

- Advanced PostgreSQL 
    - PostgreSQL PL/pgSQL
    - PostgreSQL Triggers
    - PostgreSQL Views
    - PostgreSQL Indexes
    - PostgreSQL JSON Functions 
    - PostgreSQL Window Functions 
    - PostgreSQL Administration