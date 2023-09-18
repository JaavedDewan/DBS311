--------------------------------------------------------------------------------------
-- DBS311 - Lab #3
-- Full Name : Jaaved Dewan
-- Student ID#: 126045178
-- Email : jdewan@myseneca.ca or jilred15@gmail.com
-- Section : NBB
-- Completed on: 06/09/23
-- Authenticity Declaration:
-- I declare this submission is the result of my own work and has not been
-- shared with any other student or 3rd party content provider. This submitted
-- piece of work is entirely of my own creation.
--------------------------------------------------------------------------------------

--1
SELECT last_name AS "Last Name",
 job_id AS "Job Title"
 FROM employee
 WHERE last_name != 'Davies'
 AND job_id IN
 (SELECT job_id
 FROM employee
 WHERE last_name = 'Davies');
 
 --2
 SELECT last_name AS "Last Name",
 job_id AS "Job Title",
 hire_date AS "Hire Date"
 FROM employee
 WHERE hire_date >
 (SELECT hire_date
 FROM employee
 WHERE last_name = 'Grant')
 ORDER BY 3 DESC;
 
 --3
 SELECT city AS "City",
 NVL(state_province, 'Unknown') AS "Province",
 postal_code AS "Prov_Code",
 country_id AS "Cnt_Code"
 FROM location
 WHERE country_id IN
 (SELECT country_id
 FROM country
 WHERE UPPER(country_name) LIKE 'I%')
 ORDER BY 1 ASC;
 
 --4
 SELECT last_name AS "Last Name",
 job_id AS "Job Title",
 salary AS "Salary"
 FROM employee
 WHERE salary <
 (SELECT AVG(salary)
 FROM employee
 WHERE department_id IN
 (SELECT department_id
 FROM department
 WHERE department_name LIKE 'Sales'))
 ORDER BY 3 DESC, 2;
 
 --5
 SELECT last_name AS "Last Name",
 job_id AS "Job Title",
 salary AS "Salary"
 FROM employee
 WHERE salary IN
 (SELECT salary
 FROM employee
 WHERE department_id IN
 (SELECT department_id
 FROM department
 WHERE department_name LIKE 'IT'))
 -- exclude this section if the IT members need to be shown as well
 AND department_id NOT IN (
SELECT department_id
FROM department
WHERE department_name LIKE 'IT')
------------------------------------------------------------------
ORDER BY 3 ASC, 1;
 
 --6
SELECT last_name AS "Last Name",
 salary AS "Salary"
 FROM employee
 WHERE salary < ANY
 (SELECT MIN(salary)
 FROM employee
 GROUP BY department_id)
 ORDER BY 2 DESC, 1;
 
 --7
SELECT job_id AS "Job Title", 
last_name AS "Last Name", 
salary AS "Salary"
FROM employee
WHERE (job_id, salary) IN (
SELECT job_id, MAX(salary)
FROM employee
WHERE ((job_id NOT LIKE '%PRES' AND job_id NOT LIKE '%VP' AND job_id NOT LIKE '%MAN' AND job_id NOT LIKE '%MGR'))
AND last_name != 'Hunold'
GROUP BY job_id)
ORDER BY 1 ASC;