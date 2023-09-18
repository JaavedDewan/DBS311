--------------------------------------------------------------------------------------
-- DBS311 - Lab #5
-- Full Name : Jaaved Dewan
-- Student ID#: 126045178
-- Email : jdewan@myseneca.ca or jilred15@gmail.com
-- Section : NBB
-- Completed on: 06/01/23
-- Authenticity Declaration:
-- I declare this submission is the result of my own work and has not been
-- shared with any other student or 3rd party content provider. This submitted
-- piece of work is entirely of my own creation.
--------------------------------------------------------------------------------------
--1 
SET SERVEROUTPUT ON; 
SET PAGESIZE 120;
CREATE OR REPLACE PROCEDURE Even_Odd (value IN INT) AS    
BEGIN   
IF MOD(value,2) =0 THEN     
 DBMS_OUTPUT.PUT_LINE ('The number is even');   
ELSE    
 DBMS_OUTPUT.PUT_LINE ('The number is odd');   
END IF;   
END;
/
DECLARE
 value INT :=100;  
BEGIN   
  Even_Odd(value);
END;
/
DECLARE
 value INT :=99;  
BEGIN   
  Even_Odd(value);
END;

--2
CREATE OR REPLACE PROCEDURE Find_Employee (employeeID NUMBER) AS
  firstName VARCHAR2(255 BYTE);
  lastName VARCHAR2(255 BYTE);
  email VARCHAR2(255 BYTE);
  phone VARCHAR2(255 BYTE);
  hairDate VARCHAR2(255 BYTE);
  jobTitle VARCHAR2(255 BYTE);
BEGIN
  SELECT first_name, last_name,email,phone_number,hire_date,job_id INTO firstName, lastName, email,phone,hairDate,jobTitle
  FROM employee
  WHERE employee_id = employeeID;
  DBMS_OUTPUT.PUT_LINE ('First name: ' || firstName);
  DBMS_OUTPUT.PUT_LINE ('Last name: ' || lastName);
  DBMS_OUTPUT.PUT_LINE ('Email: ' || email);
  DBMS_OUTPUT.PUT_LINE ('Phone: ' || phone);
  DBMS_OUTPUT.PUT_LINE ('Hire date: ' || hairDate);
  DBMS_OUTPUT.PUT_LINE ('Job title: ' || jobTitle);
EXCEPTION
WHEN OTHERS
  THEN 
      DBMS_OUTPUT.PUT_LINE ('Error!');
END;
/
DECLARE
 ID NUMBER :=107;  
BEGIN   
  Find_Employee(ID);
END;
/
DECLARE
 ID NUMBER :=99999;  
BEGIN   
  Find_Employee(ID);
END;

--3
CREATE OR REPLACE PROCEDURE Update_Price_by_Cat (id products.category_id%type,amount NUMBER) AS
Rows_updated NUMBER;
BEGIN
   UPDATE PRODUCTS SET List_price = List_price + amount
   WHERE CATEGORY_ID = id
  AND   LIST_PRICE > 0;
        Rows_updated := sql%rowcount;
  IF (Rows_updated = 0) then
        DBMS_OUTPUT.PUT_LINE ('Invalid Category ID');
  ELSE 
        DBMS_OUTPUT.PUT_LINE ('The number of updated rows is: ' || Rows_updated);
  END IF; 
EXCEPTION
WHEN OTHERS
  THEN 
      DBMS_OUTPUT.PUT_LINE ('Error!');
END;
/
DECLARE
     A NUMBER :=1;
     B NUMBER :=5;
    BEGIN
      Update_Price_by_Cat (A,B);
   END;
/
DECLARE
     A NUMBER :=99999;
     B NUMBER :=5;
    BEGIN
      Update_Price_by_Cat (A,B);
   END;
/
ROLLBACK;

--4

CREATE OR REPLACE PROCEDURE Update_Price_Under_Avg As 
AvgPrice PRODUCTS.List_price%type;
Rows_updated NUMBER;
BEGIN
   SELECT AVG(List_price) INTO AvgPrice From PRODUCTS;
   If AvgPrice <= 1000 THEN
    UPDATE PRODUCTS SET List_price = (List_price * 1.02)
    WHERE List_price < AvgPrice;
    Rows_updated := sql%rowcount;
   ELSE
    UPDATE PRODUCTS SET List_price = (List_price * 1.01)
    WHERE List_price < AvgPrice;
    Rows_updated := sql%rowcount;
   END IF;
   DBMS_OUTPUT.PUT_LINE ('The number of updated rows is: ' || Rows_updated);
   EXCEPTION
   WHEN OTHERS
    THEN
        DBMS_OUTPUT.PUT_LINE ('Error!');
END;
/
BEGIN 
    Update_Price_Under_Avg;
END;
/
ROLLBACK;


--5
SET SERVEROUTPUT ON; -- Enable output display

CREATE OR REPLACE PROCEDURE Product_Price_Report IS
  -- Variables for storing average, minimum, and maximum price
  avg_price NUMBER;
  min_price NUMBER;
  max_price NUMBER;
  -- Variables to store the number of products in each category
  cheap_count NUMBER := 0;
  fair_count NUMBER := 0;
  exp_count NUMBER := 0;
BEGIN
  -- Store average price, minimum price, and maximum price into variables using SELECT statement
  SELECT AVG(list_price), MIN(list_price), MAX(list_price)
  INTO avg_price, min_price, max_price
  FROM products;
  
  -- Based on condition, set cheap count
  SELECT COUNT(product_id)
  INTO cheap_count
  FROM products
  WHERE list_price < ((avg_price - min_price) / 2);
  
  -- Based on condition, set expensive count
  SELECT COUNT(product_id)
  INTO exp_count
  FROM products
  WHERE list_price > ((max_price - avg_price) / 2);
  
  -- Based on condition, set fair count
  SELECT COUNT(product_id)
  INTO fair_count
  FROM products
  WHERE list_price BETWEEN ((avg_price - min_price) / 2) AND ((max_price - avg_price) / 2);
  
  -- Display the output
  DBMS_OUTPUT.PUT_LINE('Cheap: ' || cheap_count);
  DBMS_OUTPUT.PUT_LINE('Fair: ' || fair_count);
  DBMS_OUTPUT.PUT_LINE('Expensive: ' || exp_count);
END;
/

DECLARE
BEGIN
  Product_Price_Report; -- Execute the procedure
END;
/
