/*1. Workforce Distribution 
How many employees are in each department, and which department has the highest headcount? (Concepts: SELECT, COUNT, GROUP BY, ORDER BY)*/

SELECT 
	COUNT(employee_id) AS employees,
	department_id
FROM 
	employees
GROUP BY
	department_id
ORDER BY
	employees DESC;
    
/*2. Salary Comparison 
What is the average salary per department, and which department has the highest and lowest average salaries? 
(Concepts: AVG, GROUP BY, ORDER BY, LIMIT)*/

SELECT 
	department_id,
    AVG(salary) AS Avg_Salary
FROM
	employees
GROUP BY
	department_id
ORDER BY
	Avg_Salary DESC
LIMIT 1;
    
/*3. Salary Bands for Employees 
Classify employees into three salary bands using CASE: ● Low (<5000) ● Medium (5000 – 10000) ● High (>10000) 
How many employees fall into each band? (Concepts: CASE, COUNT, GROUP BY)*/

SELECT
	COUNT(DISTINCT e.department_id) AS no_of_employees,
CASE
	WHEN salary < 5000 THEN 'Low'
    WHEN salary BETWEEN 5000 AND 10000 THEN 'Medium'
    WHEN salary > 10000 THEN 'High'
END AS salary_bands
FROM
	employees
GROUP BY
    salary_bands;

/*4. Country-Level Analysis 
List all countries in which Orion Data Systems operates. For each country, show the number of departments located there.
(Concepts: JOIN, GROUP BY, COUNT)*/

SELECT
	c.country_name,
    COUNT(e.department_id) AS no_of_dpts
FROM
	countries c
 JOIN
	employees e ON c.country_id = e.country_id
GROUP BY
	country_name;

/*5. High Earners 
Find all employees whose salaries are greater than the company-wide average salary. (Concepts: Subquery, AVG, WHERE)*/

SELECT * FROM employees 
WHERE 
	salary > (SELECT AVG(salary) FROM employees);
    
/*6. Department Leaders 
List each department along with the manager’s name and the number of employees reporting to that department. 
(Concepts: INNER JOIN, GROUP BY, COUNT)*/

SELECT
	d.department_name,
    e.manager_name,
    COUNT(e.employee_id) AS no_of_employees
FROM
	employees e
INNER JOIN 
	departments d ON e.department_id = d.department_id
GROUP BY
	department_name,
    manager_name;
    
/*7. Job Role Analysis For each job title, calculate the average salary. For each job title, calculate the average salary.
Then, identify job titles where the average salary is above 12,000. (Concepts: CTE, AVG, HAVING)*/

WITH 
	CTE_showing_AvgSal_above_12k AS (
SELECT
	j.job_title,
    ROUND(AVG(e.salary) ,2) AS avg_salary
FROM
	jobs j
JOIN
	employees e ON j.job_id = e.job_id
GROUP BY
	 job_title
HAVING
	avg_salary > 12000)
SELECT * FROM CTE_showing_AvgSal_above_12k;

/*8. Employee Ranking 
Rank employees by salary (highest to lowest) within their department. (Concepts: ROW_NUMBER, PARTITION BY, ORDER BY)*/

SELECT 
    first_name, 
    department_id, 
    salary,
ROW_NUMBER()
OVER(PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees;

/*9. Salary Growth Trend 
Calculate the total salaries paid to employees in each country. List the country name alongside the total salary cost,
 ordered from highest to lowest. (Concepts: JOIN, SUM, GROUP BY, ORDER BY)*/
 
 SELECT
	c.country_name,
    SUM(e.salary) AS Total_Salary_Cost
FROM
	employees e
JOIN
	countries c ON e.country_id = c.country_id
GROUP BY
	country_name
ORDER BY
	Total_Salary_Cost DESC;
    
/*10. Workforce Gaps 
Identify all job roles in the company (jobs table) that currently have no employees assigned. (Concepts: RIGHT JOIN, WHERE IS NULL)*/
SELECT 
	j.job_title
FROM 
	jobs j
LEFT JOIN employees e ON j.job_id = e.job_id
WHERE 
	e.employee_id IS NULL; 