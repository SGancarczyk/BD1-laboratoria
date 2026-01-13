select name, surname
from EMPLOYEES
where (DATE_EMPLOYED) > all (
    select nvl(DATE_END, sysdate)
    from projects
    );

select name, surname
from employees
where (salary) >= any(
    select 4*salary
    from employees
    );

select e.name, e.surname
from employees e join departments d using (department_id)
where (department_id) = any(
      select department_id
      from departments join addresses using(address_id)
      where COUNTRY_ID = '104');

SELECT
    e.name,
    e.surname,
    (   -- POCZĄTEK PODZAPYTANIA W SELECT
        SELECT MAX(emp.salary)
        FROM employees emp
        WHERE emp.department_id = e.department_id -- Korelacja: łączymy z tabelą zewn.
    ) AS max_pensja_w_dziale
FROM employees e
WHERE e.department_id IN (
    SELECT d.department_id
    FROM departments d
             JOIN addresses a ON d.address_id = a.address_id
    WHERE a.country_id = '104'
);



