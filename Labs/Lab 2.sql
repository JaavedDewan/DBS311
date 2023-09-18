--------------------------------------------------------------------------------------
-- DBS311 - Lab #2
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

-- 1

SELECT department_id AS "Department Number",
MAX(salary) AS "High",
MIN(salary) AS "Low",
ROUND(AVG(salary),0) AS "Average"
FROM employee
GROUP BY department_id
ORDER BY "Average" DESC;

--Department Number       High        Low    Average
------------------- ---------- ---------- ----------
--               90      24000      17000      19333
--              110      12000       8300      10150
--               80      11000       8600      10033
--               20      13000       6000       9500
--                        7000       7000       7000
--               60       9000       4200       6400
--               10       4400       4400       4400
--               50       5800       2500       3500
--
--8 rows selected.  

--------------------------------------------------------------------------------------

-- 2

SELECT department_id AS "Dept#",
job_id AS "Job",
COUNT(employee_id) AS "HowMany"
FROM employee
GROUP BY department_id, job_id
HAVING COUNT(employee_id) > 1
ORDER BY "HowMany" DESC;

--     Dept# Job           HowMany
------------ ---------- ----------
--        50 ST_CLERK            4
--        60 IT_PROG             3
--        80 SA_REP              2
--        90 AD_VP               2

--------------------------------------------------------------------------------------

-- 3

SELECT job_id AS "Job Title",
SUM(salary) AS "Total Paid"
FROM employee
GROUP BY job_id
HAVING job_id NOT IN('AD_PRES', 'AD_VP') AND
SUM(SALARY) > 15000
ORDER BY "Total Paid" DESC;

--Job Title  Total Paid
------------ ----------
--SA_REP          26600
--IT_PROG         19200

--------------------------------------------------------------------------------------

-- 4

SELECT manager_id AS "Manager Number",
COUNT(employee_id) AS "Employees"
FROM employee
GROUP BY manager_id
HAVING manager_id NOT IN(100, 101, 102) AND
manager_id IS NOT NULL AND
COUNT(employee_id) > 2
ORDER BY "Employees" DESC;

--Manager Number  Employees
---------------- ----------
--           124          4
--           149          3

--------------------------------------------------------------------------------------

-- 5

SELECT department_id AS "Department Number",
MAX(hire_date) AS "Late-HD",
MIN(hire_date) AS "Early-HD"
FROM employee
GROUP BY department_id
HAVING department_id NOT IN(10, 20) AND
MAX(hire_date) < '01-JAN-01'
ORDER BY "Late-HD" DESC;

--Department Number Late-HD  Early-HD
------------------- -------- --------
--               80 00-01-29 96-05-11
--               50 99-11-16 95-10-17
--               60 99-02-07 90-01-03
--              110 94-06-07 94-06-07
--               90 93-01-13 87-06-17

--------------------------------------------------------------------------------------

-- 6

SELECT d.department_name AS "Name",
l.city AS "City",
COUNT(*) AS "Employees"
FROM department d
JOIN employee e ON d.department_id = e.department_id
JOIN location l ON d.location_id = l.location_id
WHERE d.department_name NOT LIKE 'S%'
GROUP BY d.department_id, d.department_name, l.city
HAVING COUNT(*) >= 3
ORDER BY "Name" ASC;

--Name                           City                            Employees
-------------------------------- ------------------------------ ----------
--Executive                      Seattle                                 3
--IT                             Southlake                               3

--------------------------------------------------------------------------------------

-- 7 (Bonus)

SELECT d.department_name AS "Name",
l.city AS "City",
COUNT(e.employee_id) AS "Employees"
FROM department d
LEFT JOIN employee e ON d.department_id = e.department_id
JOIN location l ON d.location_id = l.location_id
WHERE d.department_name NOT LIKE 'A%'
GROUP BY d.department_id, d.department_name, l.city
HAVING COUNT(e.employee_id) < 3 OR COUNT(e.employee_id) IS NULL
ORDER BY "Name" ASC;

--Name                           City                            Employees
-------------------------------- ------------------------------ ----------
--Contracting                    Seattle                                 0
--Marketing                      Toronto                                 2

--------------------------------------------------------------------------------------