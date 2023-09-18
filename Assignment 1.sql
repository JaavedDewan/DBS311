--------------------------------------------------------------------------------------
-- DBS311 - Assignment 1
-- Full Name : Ishwinder Singh, Jaaved Dewan, Sara Nasifa Zaman, Simranjot Singh
-- Student ID#: 126045178
-- Email : jdewan@myseneca.ca or jilred15@gmail.com
-- Section : NBB
-- Completed on: 05/25/23
-- Authenticity Declaration:
-- I declare this submission is the result of my own work and has not been
-- shared with any other student or 3rd party content provider. This submitted
-- piece of work is entirely of my own creation.
--------------------------------------------------------------------------------------

--1

SELECT 
  employee_id  AS "Emp Id",
  SUBSTR(last_name ||', '|| first_name, 1, 20) AS "Full Name", 
  SUBSTR(job_title, 1, 15) AS "Job", 
  TO_CHAR(hire_date, '[Month ddth "of" YYYY]') AS "Start Date"
FROM employees
WHERE LOWER(job_title) NOT LIKE 'admin%'
AND EXTRACT(MONTH FROM hire_date) = 9
ORDER BY 4 DESC, last_name ASC;

--    Emp Id Full Name            Job             Start Date              
------------ -------------------- --------------- ------------------------
--        12 James, Elliott       Accountant      [September 30th of 2016]
--        27 Long, Kai            Stock Clerk     [September 28th of 2016]
--        11 Ramirez, Tyler       Accountant      [September 28th of 2016]

--------------------------------------------------------------------------------------
--2
SELECT 
NVL(o.salesman_id, 0) AS "Employee Id", 
TO_CHAR(SUM(oi.quantity*oi.unit_price),'$999,999,999.99') AS "Total Sale"
FROM orders o LEFT JOIN order_items oi
USING (order_id)
GROUP BY o.salesman_id
ORDER BY 1;

--Employee Id Total Sale      
------------- ----------------
--          0   $18,245,463.50
--         54    $1,884,295.40
--         55    $3,525,462.19
--         56    $2,754,951.05
--         57    $3,522,704.53
--         59    $3,900,172.99
--         60    $3,233,737.31
--         61    $3,252,131.23
--         62    $8,081,332.30
--         64    $4,341,842.14
--
--10 rows selected. 

--------------------------------------------------------------------------------------
--3
SELECT 
c.customer_id AS "CustId", 
SUBSTR(c.name, 1, 20) AS "Name",
COUNT(o.order_id) AS "Total Orders"
FROM customers c LEFT JOIN orders o
ON c.customer_id=o.customer_id
WHERE c.customer_id<200
AND SUBSTR(name,1,1) IN('F','J')
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id)<3
ORDER BY 3 ASC, 2 ASC;

--   CustId Name                 Total Orders
------------ -------------------- ------------
--       103 Fannie Mae                      0
--       150 FedEx                           0
--        77 FirstEnergy                     0
--        40 Fluor                           0
--        96 Ford Motor                      0
--       135 Freddie Mac                     0
--       110 J.P. Morgan Chase               0
--       131 Johnson & Johnson               0
--       165 Johnson Controls                0
--        43 Facebook                        1
--        61 Freeport-McMoRan                1
--
--11 rows selected. 

--------------------------------------------------------------------------------------
--4
SELECT 
c.customer_id AS "Cust#", 
SUBSTR(c.name, 1, 20)AS "Name", 
o.order_id AS "Order Id", 
TO_CHAR(o.order_date, 'dd-MON-yy') AS "Order Dat", 
SUM(i.quantity) AS "Total# of Units", 
TO_CHAR(SUM(i.quantity*i.unit_price),'FM$999,999,999.99') AS "Total Amount"
FROM customers c JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items i
ON o.order_id=i.order_id
WHERE c.customer_id=44
GROUP BY c.customer_id, c.name, o.order_id, o.order_date
HAVING SUM(i.quantity*i.unit_price)<=1000000
ORDER BY 6 DESC;

--    Cust# Name                   Order Id Order Dat Total# of Units Total Amount    
------------ -------------------- ---------- --------- --------------- ----------------
--        44 Jabil Circuit                69 17-MAR-17             581 $755,093.92     
--        44 Jabil Circuit                10 24-JAN-17             883 $620,962.99     
--        44 Jabil Circuit                29 14-AUG-17             831 $508,588.59     
--        44 Jabil Circuit                82 03-DEC-16             687 $398,636.25 

--------------------------------------------------------------------------------------
--5
SELECT c.customer_id AS "Cust#", 
SUBSTR(c.name, 1, 20) AS "Name",
COUNT(DISTINCT o.order_id) AS "# of Orders",
COUNT(oi.item_id) AS "# of Items",
SUM(oi.quantity) AS "Total# of Units",
'$' || TO_CHAR(SUM(oi.quantity * oi.unit_price), 'FM999,999,999,999.00') AS "Grand Total Amount"
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
HAVING COUNT(DISTINCT o.order_id) > 4
ORDER BY 3 ASC, 2 ASC;

--  Cust# Name                 # of Orders # of Items Total# of Units Grand Total Amount  
------------ -------------------- ----------- ---------- --------------- --------------------
--        45 CenturyLink                    5         25            2367 $2,404,865.96       
--        47 General Mills                  5         33            3116 $3,725,138.14       
--        44 Jabil Circuit                  5         45            3772 $3,334,221.72       
--        49 NextEra Energy                 5         37            3351 $2,452,508.95       
--        48 Southern                       5         27            2313 $2,205,645.93       
--        46 Supervalu                      5         27            2263 $1,914,056.90       
--
--6 rows selected. 

--------------------------------------------------------------------------------------
--6
SELECT i.warehouse_id AS "Wrhs#", 
SUBSTR(w.warehouse_name, 1,20) AS "Warehouse Name", 
c.category_id AS "Category ID", 
SUBSTR(c.category_name, 1, 15) AS "Category Name", 
TO_CHAR(MIN(p.standard_cost),'$999,999,999.99') AS "Lowest Cost"
FROM warehouses w JOIN inventories i
ON w.warehouse_id=i.warehouse_id
JOIN products p
ON i.product_id=p.product_id
JOIN product_categories c
ON p.category_id=c.category_id
GROUP BY i.warehouse_id, w.warehouse_name, c.category_id, c.category_name
HAVING MIN(p.standard_cost) NOT BETWEEN 200 AND 500
ORDER BY 1, 2, 3, 4;

--     Wrhs# Warehouse Name       Category ID Category Name   Lowest Cost     
------------ -------------------- ----------- --------------- ----------------
--         1 Southlake, Texas               2 Video Card               $535.03
--         2 San Francisco                  2 Video Card               $521.03
--         2 San Francisco                  5 Storage                   $12.63
--         3 New Jersey                     2 Video Card               $535.03
--         4 Seattle, Washington            2 Video Card               $535.03
--         5 Toronto                        2 Video Card               $521.03
--         5 Toronto                        5 Storage                   $12.63
--         6 Sydney                         2 Video Card               $521.03
--         6 Sydney                         5 Storage                   $12.63
--         7 Mexico City                    2 Video Card               $535.03
--         7 Mexico City                    5 Storage                   $12.63
--
--     Wrhs# Warehouse Name       Category ID Category Name   Lowest Cost     
------------ -------------------- ----------- --------------- ----------------
--         8 Beijing                        2 Video Card               $535.03
--         8 Beijing                        5 Storage                   $12.63
--         9 Bombay                         2 Video Card               $535.03
--
--14 rows selected. 

--------------------------------------------------------------------------------------
--7
SELECT
    p.product_id AS "ProdId",
    SUBSTR(p.product_name, 1, 20) AS "Product Name",
    p.list_price AS "LPrice"
FROM
    products p
WHERE
    p.list_price > ALL (
        SELECT
            a.price
        FROM
            (
                SELECT AVG(list_price) AS price, category_id AS category
                FROM products
                GROUP BY category_id
            ) a
    )
    AND p.product_id IN (
        SELECT
            i.product_id
        FROM
            order_items i
        WHERE
            i.order_id IN (
                SELECT
                    o.order_id
                FROM
                    orders o
                WHERE
                    o.salesman_id = (
                        SELECT
                            employee_id
                        FROM
                            employees
                        WHERE
                            LOWER(last_name) = 'marshall'
                    )
            )
    )
ORDER BY
    p.product_id ASC;

--   ProdId Product Name             LPrice
------------ -------------------- ----------
--         2 Intel Xeon E5-2697 V    2554.99
--        45 Intel Xeon E5-2685 V    2501.69
--        51 Intel Xeon E5-2695 V    2269.99
--        91 Intel Xeon E5-2695 V    2259.99
--       102 Intel Xeon E5-2687W     2042.69
--       110 ATI FirePro W9000       3192.97
--       178 HP C2J95AT              1999.89
--       207 PNY VCQM6000-PB         3254.99
--       213 Intel Xeon E5-2643 V    1469.96
--
--9 rows selected. 

--------------------------------------------------------------------------------------
--8
SELECT 
  o.customer_id AS "Customer ID", 
  SUBSTR(c.name, 1, 20) AS "Customer Name",
  COUNT(o.order_id) AS "# of Orders"
FROM 
  orders o 
  LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE 
  (o.salesman_id = (SELECT employee_id FROM employees WHERE UPPER(last_name) = 'MARSHALL') OR o.salesman_id IS NULL)
  AND (UPPER(SUBSTR(c.name, 1, 7)) = 'GENERAL' OR UPPER(SUBSTR(c.name, -8, 8)) = 'ELECTRIC')
GROUP BY 
  o.customer_id, c.name
HAVING 
  COUNT(o.order_id) != 1
UNION
SELECT 
  customer_id, 
  SUBSTR(name, 1, 20) AS "Customer Name", 
  NVL(TO_NUMBER(NULL), 0)
FROM 
  customers
WHERE 
  customer_id NOT IN (SELECT customer_id FROM orders)
  AND (UPPER(SUBSTR(name, 1, 7)) = 'GENERAL' OR UPPER(SUBSTR(name, -8, 8)) = 'ELECTRIC')
ORDER BY 
  3 DESC, 2;

--Customer ID Customer Name        # of Orders
------------- -------------------- -----------
--         47 General Mills                  3
--          9 Emerson Electric               2
--        185 General Dynamics               0
--         98 General Electric               0
--         95 General Motors                 0

--------------------------------------------------------------------------------------
--9
SELECT pr.product_id "Product ID", 
SUBSTR(pr.product_name, 1,20) "Product Name", 
TO_CHAR(pr.list_price,'$999,999,999.99') "List Price"
FROM products pr
WHERE pr.list_price>ANY(SELECT MAX(p.standard_cost)
FROM products p JOIN inventories i ON p.product_id=i.product_id
JOIN warehouses w ON i.warehouse_id=w.warehouse_id
JOIN locations l ON w.location_id=l.location_id
JOIN countries c ON l.country_id=c.country_id
JOIN regions r ON c.region_id=r.region_id
WHERE LOWER (r.region_name)!='americas'
GROUP BY w.warehouse_id) 
ORDER BY 3 DESC;

--Product ID Product Name         List Price      
------------ -------------------- ----------------
--        50 Intel SSDPECME040T40        $8,867.99
--       133 PNY VCQP6000-PB             $5,499.99
--       206 PNY VCQM6000-24GB-PB        $4,139.00


--------------------------------------------------------------------------------------
--10
SELECT product_id AS "Product ID", 
SUBSTR(product_name, 1,20) AS "Product Name", 
TO_CHAR(list_price,'$999,999,999.99') AS "Price"
FROM products
WHERE list_price=(SELECT MAX(list_price) FROM products)
UNION 
SELECT product_id "Product ID", 
SUBSTR(product_name, 1,20) AS "Product Name", 
TO_CHAR(list_price,'$999,999,999.99') "Price"
FROM products
WHERE list_price=(SELECT MIN(list_price) FROM products)
UNION
(SELECT product_id "Product ID", 
SUBSTR(product_name,1,20) AS "Product Name", 
TO_CHAR(list_price,'$999,999,999.99') AS "Price"
FROM products
WHERE LOWER(product_name) NOT LIKE 'intel%'
ORDER BY ABS((SELECT ROUND(AVG(list_price),-1) FROM products)-list_price)
FETCH NEXT ROW ONLY);

--Product ID Product Name         Price           
------------ -------------------- ----------------
--        50 Intel SSDPECME040T40        $8,867.99
--        94 Western Digital WD25           $15.55
--       183 Asus GTX780TI-3GD5            $899.99