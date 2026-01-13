SELECT
    e.name AS imie,
    COUNT(*) AS liczba_osob,
    AVG(e.salary) AS srednie_zarobki
FROM employees e
         JOIN departments d ON e.department_id = d.department_id
WHERE d.name IN ('Administracja', 'Marketing')
GROUP BY e.name;

select e.name, e.surname, count(*)
from employees e join POSITIONS_HISTORY using(employee_id)
group by e.name, e.SURNAME
having count(*) > 2
order by count(*) desc;

select e.employee_id, e.surname, count(*)
from employees e join employees emp on (emp.manager_id = e.EMPLOYEE_ID)
group by e.EMPLOYEE_ID, e.surname
order by count(*) desc;

select c.name, c.population, count(*)
from countries c join addresses a using (country_id) join departments d on (a.address_id = d.address_id)
group by c.name, c.population;

select r.name, count(*)
from regions r join reg_countries rc using (region_id)
    join addresses a on (rc.COUNTRY_ID = a.COUNTRY_ID)
    join departments d on (a.ADDRESS_ID = d.ADDRESS_ID)
group by r.name
order by count(*) desc;



