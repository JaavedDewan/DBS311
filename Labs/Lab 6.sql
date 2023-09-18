--1

SET SERVEROUTPUT ON; -- Enable output display

CREATE OR REPLACE PROCEDURE Get_Fact(n INTEGER) AS
  factorial INTEGER := 1;
BEGIN
  FOR i IN REVERSE 1..n LOOP
    factorial := factorial * i;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE(n || '! = ' || factorial);
END;
/

DECLARE
  n INTEGER := 4; -- Example input value
  m INTEGER := 0;
BEGIN
  Get_Fact(n);
  Get_Fact(m);
END;
/


--2
CREATE OR REPLACE PROCEDURE Calculate_Salary (empID employee.employee_id%type) AS

emp employee%rowtype;
newSalary employee.salary%type;
yearsWorked INTEGER;

BEGIN
    SELECT * INTO emp
    FROM employee

    WHERE employee_id = empID;
    
    newSalary := emp.salary; --starting salary
    yearsWorked := trunc(MONTHS_BETWEEN(SYSDATE, emp.hire_date) / 12); --trunc so we dont round up an extra year
    
    FOR year IN 1..yearsWorked LOOP
        newSalary := newSalary * 1.05;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('First Name: ' || emp.first_name);
    DBMS_OUTPUT.PUT_LINE('Last Name: ' || emp.last_name);
    DBMS_OUTPUT.PUT_LINE('Annual Salary: $' || to_char(newSalary, '$99,999')); 
    
    EXCEPTION WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Employee (ID: ' || empID || ') does not exist.');

END;
/
DECLARE
  empID1 employee.employee_id%type := 124;
  empID2 employee.employee_id%type := 0; 
BEGIN
  Calculate_Salary(empID2);
  Calculate_Salary(empID1);
END;
/

--3
SET SERVEROUTPUT ON; -- Enable output display

CREATE OR REPLACE PROCEDURE Find_Prod_Price (prodID IN products.product_id%type, d OUT VARCHAR2, note OUT VARCHAR2) IS
  prodPrice products.list_price%type;
BEGIN
  SELECT description, list_price INTO d, prodPrice
  FROM products
  WHERE product_id = prodID;
  
  IF prodPrice < 200 THEN
    note := 'Cheap';
  ELSIF prodPrice BETWEEN 200 AND 500 THEN
    note := 'Not Expensive';
  ELSE
    note := 'Expensive';
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(d || ' is ' || note);
  
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Invalid Product ID: ' || prodID);
END;
/

DECLARE
  prodID products.product_id%type := 94;
  prodID2 products.product_id%type := 64;
  prodID3 products.product_id%type := 0;
  p_desc VARCHAR2(100);
  p_note VARCHAR2(100);
BEGIN
  Find_Prod_Price(prodID, p_desc, p_note);
  Find_Prod_Price(prodID2, p_desc, p_note);
  Find_Prod_Price(prodID3, p_desc, p_note);
END;
/

--4
CREATE OR REPLACE PROCEDURE Warehouses_Report IS
  P_warehouse_ID NUMBER;
  P_warehouse_NAME VARCHAR2(45);
  P_City VARCHAR2(45);
  P_State VARCHAR2(45);
BEGIN
  -- Using a FOR loop to loop through the records
  FOR l_counter IN 1..9 LOOP
    -- Getting the record and storing the values in locally declared variables
    SELECT warehouse_id, warehouse_name, city, NVL(state, 'no state')
    INTO P_warehouse_ID, P_warehouse_NAME, P_City, P_State
    FROM warehouses w
    JOIN locations l ON w.location_id = l.location_id
    WHERE warehouse_id = l_counter;
    
    -- Displaying the final message as required with aligned columns
    DBMS_OUTPUT.PUT_LINE('Warehouse ID:     ' || P_warehouse_ID);
    DBMS_OUTPUT.PUT_LINE('Warehouse Name:   ' || P_warehouse_NAME);
    DBMS_OUTPUT.PUT_LINE('City:             ' || P_City);
    DBMS_OUTPUT.PUT_LINE('State:            ' || P_State);
    DBMS_OUTPUT.PUT_LINE(''); -- Empty line for better readability
  END LOOP;
END;
/
BEGIN
  Warehouses_Report;
END;
/
