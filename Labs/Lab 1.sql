
--------------------------------------------------------------------------------------
-- DBS311 - Lab #1
-- Full Name : Jaaved Dewan
-- Student ID#: 126045178
-- Email : jdewan@myseneca.ca or jilred15@gmail.com
-- Section : NBB
-- Completed on: 05/25/23
-- Authenticity Declaration:
-- I declare this submission is the result of my own work and has not been
-- shared with any other student or 3rd party content provider. This submitted
-- piece of work is entirely of my own creation.
--------------------------------------------------------------------------------------


-- 1. Display the date after tomorrow in the format: September 28th of year 2016
-- The result will depend on the day when you create this query.
-- Label the column as "After Tomorrow".

SELECT TO_CHAR(SYSDATE + INTERVAL '2' DAY, 'Month ddth "of year" YYYY') AS "After Tomorrow"
FROM dual;


-- Output: (First two dashes are to make the output into a comment)

-- After Tomorrow       
-- ---------------------
-- May       28th of year 2023
--
-- 1 row selected.  

--------------------------------------------------------------------------------------
-- 2 
-- For each employee in departments 50 and 60 display last name, first name, salary, and salary increased by 7% and expressed as a whole number.
-- Label the column  Good Salary. 
-- Also add a column that subtracts the old salary from the new salary and multiplies by 12.  Label the column  Annual Pay Increase.

SELECT
last_name AS "Last Name",
first_name AS "First Name",
salary AS "Salary",
ROUND(salary*1.07, 0) AS "Good Salary", (salary*1.07-salary)*12 AS "Annual Pay Increase"
FROM employee
WHERE department_id = 50 OR department_id = 60;

-- Output: (First two dashes are to make the output into a comment)

-- Last Name                 First Name               Salary Good Salary Annual Pay Increase
-- ------------------------- -------------------- ---------- ----------- -------------------
-- Mourgos                   Kevin                      5800        6206                4872
-- Rajs                      Trenna                     3500        3745                2940
-- Davies                    Curtis                     3100        3317                2604
-- Matos                     Randall                    2600        2782                2184
-- Vargas                    Peter                      2500        2675                2100
-- Hunold                    Alexander                  9000        9630                7560
-- Ernst                     Bruce                      6000        6420                5040
-- Lorentz                   Diana                      4200        4494                3528
--
-- 8 rows selected. 

--------------------------------------------------------------------------------------
-- 3
-- Write a query that displays the employee’s Full Name and Job Title in the following format:
-- DAVIES, CURTIES is Stock Clerk 
-- for all employees whose last name ends with S and first name starts with  C or K.
-- Give this column an appropriate label like Person and Job
-- Sort the result by the employees’ last names.

SELECT
UPPER(last_name) || ', ' || UPPER(first_name) || ' is ' ||
CASE job_id
WHEN 'ST_CLERK' THEN 'Stock Clerk'
WHEN 'ST_MAN' THEN 'Stock Manager'
ELSE job_id
END AS "Person and Job"
FROM employee
WHERE last_name LIKE '%s' AND (first_name LIKE 'C%' OR first_name LIKE 'K%')
ORDER BY last_name;

-- Output: (First two dashes are to make the output into a comment)

-- Person and Job                                                  
-- ----------------------------------------------------------------
-- DAVIES, CURTIS is Stock Clerk
-- MOURGOS, KEVIN is Stock Manager
--
-- 2 rows selected. 

--------------------------------------------------------------------------------------

-- 4
-- For each employee hired before 1992 who is earning more than $10000, display the employee’s last name, salary, hire date and calculate the number of YEARS between TODAY and the date the employee was hired. 
-- Round the number of years up to the closest whole number. Label the column Years Worked. 
-- Order your results by the highest paid people first, then by years worked. 

SELECT
 last_name AS "Last Name",
 salary AS "Salary",
 hire_date AS "HireDate",
 round((months_between (sysdate, hire_date)/12), 0) AS "Years Worked"
 FROM employee
 WHERE salary > 10000 AND hire_date < '1992-01-01'
 ORDER BY salary DESC;

-- Output: (First two dashes are to make the output into a comment)

-- Last Name                     Salary HireDate Years Worked
-- ------------------------- ---------- -------- ------------
-- King                           24000 87-06-17           36
-- Kochhar                        17000 89-09-21           34
--
-- 2 rows selected.

--------------------------------------------------------------------------------------

-- 5
-- Create a query that displays the city names, country codes and state province names, but only for those cities that start on S and have at least 8 characters in their name. 
-- If city does not have province name assigned, then put Unknown Province.

SELECT
city AS "City",
country_id,
NVL (state_province, 'Unknown Province') AS "Province"
FROM location
WHERE city LIKE 'S_______%';

-- Output: (First two dashes are to make the output into a comment)

-- City                           CO Province                 
-- ------------------------------ -- -------------------------
-- Sao Paulo                      BR Sao Paulo                
-- Singapore                      SG Unknown Province         
-- South Brunswick                US New Jersey               
-- South San Francisco            US California               
-- Southlake                      US Texas                    
-- Stretford                      UK Manchester               
--
-- 6 rows selected.

--------------------------------------------------------------------------------------

-- 6
-- Display each employee’s last name, hire date, and salary review date, which is the first Tuesday after a year of service, but only for those hired after 1997.
-- Label the column REVIEW DAY. Format the dates to appear in the format similar to:  TUESDAY, August the Thirty-First of year 1998

SELECT
last_name AS "LAST NAME",
TO_CHAR(hire_date,  'DAY, Month "the" fmDdspth "of year" YYYY') AS "HIRE DATE",
TO_CHAR((NEXT_DAY(hire_date + 365, 'Tuesday')), 'DAY, Month "the" fmDdspth "of year" YYYY') AS "REVIEW DAY"
FROM
employee
WHERE
hire_date > '1997-12-31';

-- Output: (First two dashes are to make the output into a comment)

-- LAST NAME                 HIRE DATE                                            REVIEW DAY                                          
-- ------------------------- ---------------------------------------------------- ----------------------------------------------------
-- Lorentz                   SUNDAY   , February  the Seventh of year 1999        TUESDAY  , February  the Eighth of year 2000        
-- Mourgos                   TUESDAY  , November  the Sixteenth of year 1999      TUESDAY  , November  the Twenty-First of year 2000  
-- Matos                     SUNDAY   , March     the Fifteenth of year 1998      TUESDAY  , March     the Sixteenth of year 1999     
-- Vargas                    THURSDAY , July      the Ninth of year 1998          TUESDAY  , July      the Thirteenth of year 1999    
-- Zlotkey                   SATURDAY , January   the Twenty-Ninth of year 2000   TUESDAY  , January   the Thirtieth of year 2001     
-- Taylor                    TUESDAY  , March     the Twenty-Fourth of year 1998  TUESDAY  , March     the Thirtieth of year 1999     
-- Grant                     MONDAY   , May       the Twenty-Fourth of year 1999  TUESDAY  , May       the Thirtieth of year 2000     
--
-- 7 rows selected. 