SELECT
    e.name AS imie,
    e.surname AS nazwisko,
    d.name AS nazwa_zakladu
FROM employees e
         JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT min_salary
    FROM positions
    WHERE name = 'Konsultant'
);

select name, surname from DEPENDENTS
where (BIRTH_DATE) = (
    select max(BIRTH_DATE)
    from dependents
    );

select d.name, d.surname
from dependents d join EMPLOYEES using (employee_id)
where (EMPLOYEES.BIRTH_DATE, DEPARTMENT_ID) = (
    select BIRTH_DATE, DEPARTMENT_ID
    from EMPLOYEES
    where department_id = '102'
    order by BIRTH_DATE
    fetch first 1 row only
    );

select e.name, e.surname
from EMPLOYEES e
where (e.DATE_EMPLOYED) >= (
    select DATE_EMPLOYED
    from EMPLOYEES
    where DEPARTMENT_ID = '101'
    order by DATE_EMPLOYED
    fetch first 1 row only
    ) and (e.DATE_EMPLOYED) <= (
        select date_employed
        from employees
        where DEPARTMENT_ID = '107'
        order by DATE_EMPLOYED desc
        fetch first 1 row only
    );

select d.name, avg(e.salary), avg(e.SALARY) - (
select avg(salary)
from EMPLOYEES e join departments d using (department_id)
where d.name = 'Administracja'
    )
from departments d join employees e using (department_id)
group by d.name;


