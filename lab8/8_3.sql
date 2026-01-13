select e.name, e.surname
from employees e
where (SALARY) > (
    select avg(emp.SALARY)
    from EMPLOYEES emp
    where emp.DEPARTMENT_ID = e.department_id
);

select r.region_id, r.name
from regions r
where not exists(
    select rc.region_id
    from REG_COUNTRIES rc
    where rc.region_id = r.region_id
);

select c.name
from countries c
where not exists(
    select rc.country_id
    from REG_COUNTRIES rc
    where rc.COUNTRY_ID = c.country_id
);

select e.name, e.surname from employees e
where not exists(
    select emp.employee_id
    from employees emp
    where emp.MANAGER_ID = e.EMPLOYEE_ID
);

SELECT e.name, e.surname
FROM employees e
WHERE e.salary > (
    SELECT AVG(emp.salary)
    FROM employees emp
    WHERE emp.position_id = e.position_id
);

select p.name
from POSITIONS p
where not exists (
    select EMPLOYEE_ID
    from EMPLOYEES
    where position_id = p.position_id
);