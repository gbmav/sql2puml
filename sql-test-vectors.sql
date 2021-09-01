CREATE TABLE table1_single_column (id INT );
CREATE TABLE table2_single_column_multi_line_sql (
id INT );

CREATE TABLE table3_3_cols (id1 INT , firstname2 VARCHAR(100), lastname3 VARCHAR(100) );
CREATE TABLE table4_3_cols_and_pk (id INT PRIMARY KEY, firstname VARCHAR(100), lastname VARCHAR(100) );
CREATE TABLE table5_3_cols_pk_in_last_col ( firstname VARCHAR(100), lastname VARCHAR(100), id INT PRIMARY KEY );

CREATE TABLE table11 ( id INT, townname VARCHAR (100), county VARCHAR(100) );
CREATE TABLE table10_pk_and_fk (id INT PRIMARY KEY, firstname VARCHAR(100), lastname VARCHAR(100) , town_id INT, FOREIGN KEY (town_id) REFERENCES table11(id));


CREATE TABLE table14 ( id INT, country VARCHAR (100));
CREATE TABLE table13_fk ( id INT, townname VARCHAR (100), county VARCHAR(100), country_id INT , FOREIGN KEY (country_id) REFERENCES table14(id) );
CREATE TABLE table12_fk (id INT PRIMARY KEY, firstname VARCHAR(100), lastname VARCHAR(100) , town_id INT ,FOREIGN KEY (town_id) REFERENCES table13_fk(id));

CREATE TABLE table15_fk_to_missing_table (id INT PRIMARY KEY,first_name VARCHAR(100) NOT NULL,last_name VARCHAR(100) NOT NULL,city_id INT ,FOREIGN KEY (city_id) REFERENCES city(id) );
