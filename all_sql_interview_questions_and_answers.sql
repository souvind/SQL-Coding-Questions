-- all_sql_interview_questions_and_answers.sql
-- Comprehensive SQL Q&A for interview preparation.

------------------------------------------------------------
-- 1. Create a table
------------------------------------------------------------
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT
);

------------------------------------------------------------
-- 2. Insert sample data
------------------------------------------------------------
INSERT INTO employees (employee_id, employee_name, department_id, salary, hire_date, manager_id)
VALUES
(1, 'Alice', 10, 70000, '2022-01-15', NULL),
(2, 'Bob', 20, 60000, '2021-03-12', 1),
(3, 'Charlie', 10, 80000, '2020-06-23', 1),
(4, 'David', 30, 75000, '2022-07-19', 2),
(5, 'Eve', 20, 90000, '2023-02-11', 2);

------------------------------------------------------------
-- 3. Select all employees
------------------------------------------------------------
SELECT * FROM employees;

------------------------------------------------------------
-- 4. Find employees in department 10
------------------------------------------------------------
SELECT * FROM employees WHERE department_id = 10;

------------------------------------------------------------
-- 5. Count employees per department
------------------------------------------------------------
SELECT department_id, COUNT(*) AS emp_count
FROM employees
GROUP BY department_id;

------------------------------------------------------------
-- 6. Find average salary per department
------------------------------------------------------------
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

------------------------------------------------------------
-- 7. Get highest salary overall
------------------------------------------------------------
SELECT MAX(salary) AS highest_salary FROM employees;

------------------------------------------------------------
-- 8. Get second highest salary
------------------------------------------------------------
SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);

------------------------------------------------------------
-- 9. Get nth highest salary (example: 3rd highest)
------------------------------------------------------------
SELECT salary
FROM employees e1
WHERE 3 = (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.salary >= e1.salary
);

------------------------------------------------------------
-- 10. Find employees without manager
------------------------------------------------------------
SELECT * FROM employees WHERE manager_id IS NULL;

------------------------------------------------------------
-- 11. Find duplicate salaries
------------------------------------------------------------
SELECT salary, COUNT(*) AS count
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;

------------------------------------------------------------
-- 12. Delete duplicates (keeping lowest ID)
------------------------------------------------------------
DELETE FROM employees
WHERE employee_id NOT IN (
    SELECT MIN(employee_id)
    FROM employees
    GROUP BY employee_name, department_id, salary, hire_date, manager_id
);

------------------------------------------------------------
-- 13. Employees hired in last 6 months
------------------------------------------------------------
SELECT *
FROM employees
WHERE hire_date >= CURRENT_DATE - INTERVAL '6' MONTH;

------------------------------------------------------------
-- 14. Join with departments
------------------------------------------------------------
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

SELECT e.employee_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

------------------------------------------------------------
-- 15. Left join example
------------------------------------------------------------
SELECT c.customer_id, c.customer_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

------------------------------------------------------------
-- 16. Customers without orders
------------------------------------------------------------
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

------------------------------------------------------------
-- 17. Window function: rank salaries per department
------------------------------------------------------------
SELECT employee_name, department_id, salary,
       RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM employees;

------------------------------------------------------------
-- 18. Window function: running total
------------------------------------------------------------
SELECT employee_name, hire_date, salary,
       SUM(salary) OVER (ORDER BY hire_date) AS running_total
FROM employees;

------------------------------------------------------------
-- 19. CTE example
------------------------------------------------------------
WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT e.employee_name, e.salary, d.avg_salary
FROM employees e
JOIN dept_avg d ON e.department_id = d.department_id;

------------------------------------------------------------
-- 20. Update salary
------------------------------------------------------------
UPDATE employees
SET salary = salary * 1.1
WHERE department_id = 10;

------------------------------------------------------------
-- 21. Delete an employee
------------------------------------------------------------
DELETE FROM employees WHERE employee_id = 5;

------------------------------------------------------------
-- 22. Add a new column
------------------------------------------------------------
ALTER TABLE employees ADD COLUMN email VARCHAR(255);

------------------------------------------------------------
-- 23. Drop a column
------------------------------------------------------------
ALTER TABLE employees DROP COLUMN email;

------------------------------------------------------------
-- 24. Create index
------------------------------------------------------------
CREATE INDEX idx_emp_dept ON employees(department_id);

------------------------------------------------------------
-- 25. Drop index
------------------------------------------------------------
DROP INDEX idx_emp_dept;

------------------------------------------------------------
-- 26. Group employees by hire year
------------------------------------------------------------
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, COUNT(*) AS emp_count
FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date);

------------------------------------------------------------
-- 27. Filter groups with HAVING
------------------------------------------------------------
SELECT department_id, COUNT(*) AS emp_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

------------------------------------------------------------
-- 28. Subquery in SELECT
------------------------------------------------------------
SELECT employee_id, employee_name,
       (SELECT department_name FROM departments d WHERE d.department_id = e.department_id) AS dept_name
FROM employees e;

------------------------------------------------------------
-- 29. Self join
------------------------------------------------------------
SELECT e.employee_name AS emp, m.employee_name AS mgr
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id;

------------------------------------------------------------
-- 30. Find employees with salary above department average
------------------------------------------------------------
SELECT employee_name, salary, department_id
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);
