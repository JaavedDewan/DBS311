--------------------------------------------------------------------------------------
-- DBS311 - Lab #4
-- Full Name : Jaaved Dewan
-- Student ID#: 126045178
-- Email : jdewan@myseneca.ca or jilred15@gmail.com
-- Section : NBB
-- Completed on: 06/16/23
-- Authenticity Declaration:
-- I declare this submission is the result of my own work and has not been
-- shared with any other student or 3rd party content provider. This submitted
-- piece of work is entirely of my own creation.
--------------------------------------------------------------------------------------

--1
SELECT 
department_id AS "Department ID"
FROM employee
MINUS
SELECT department_id
FROM employee
WHERE UPPER(job_id) = UPPER('ST_CLERK')
ORDER BY 1;

--2
SELECT 
employee_id AS "Employee ID",
job_id AS "Job ID",
salary AS "Salary"
FROM employee
UNION
SELECT employee_id, job_id, -1 AS Salary
FROM job_history;


--3
SELECT city AS "City"
FROM locations
MINUS
SELECT l.city
FROM locations l
INNER JOIN warehouses w ON l.location_id = w.location_id
ORDER BY 1;

--4
SELECT 
  pc.category_id AS "Category ID", 
  SUBSTR(pc.category_name, 1, 15) AS "Category Name", 
  COUNT(p.category_id) AS "Product Count"
FROM product_categories pc
JOIN products p ON pc.category_id = p.category_id
WHERE pc.category_id IN (5, 1, 2)
GROUP BY pc.category_id, pc.category_name
ORDER BY 3 DESC;

--5
SELECT DISTINCT oi.product_id AS "Product ID" --remove DISTINCT if duplicants must be shown
FROM order_items oi
WHERE oi.product_id IN (
  SELECT i.product_id
  FROM inventories i
  WHERE i.quantity > 250)
ORDER BY 1;

--6
SELECT 
  l.location_id AS "Loc#", 
  l.city AS "City", 
  COALESCE(l.state, 'No State') AS "State",
  NULL AS "Warehouse"
FROM 
  locations l
UNION ALL
SELECT 
  l.location_id AS "Loc#", 
  '' AS "City", 
  '' AS "State",
  w.warehouse_name AS "Warehouse"
FROM 
  locations l, warehouses w
WHERE 
  l.location_id = w.location_id
ORDER BY 
  1, 4 NULLS FIRST;