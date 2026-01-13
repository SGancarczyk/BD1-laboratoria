select e.surname, s.name, e.salary, s.min_salary, s.max_salary
from EMPLOYEES e left join positions s using(position_id);

select s.name, avg(e.salary), count(*)
from employees e right join positions s using(position_id)
group by s.name;

select p.name, count(*)
from projects p left join emp_projects ep using(project_id) join employees e using(employee_id)
group by p.name;

SELECT
    d.name,  -- lub d.name, zależnie od nazwy kolumny w tabeli
    nvl(AVG(g.grade), 0) as srednia_ocena
FROM
    departments d
        -- 1. Dołączamy pracowników (LEFT, żeby nie zgubić pustych departamentów)
        LEFT JOIN employees e ON d.department_id = e.department_id
        -- 2. Dołączamy tabelę łączącą oceny (LEFT, żeby nie zgubić pracowników bez oceny)
        LEFT JOIN emp_grades eg ON e.employee_id = eg.employee_id
        -- 3. Dołączamy definicje ocen (LEFT, dla spójności)
        LEFT JOIN grades g ON eg.grade_id = g.grade_id
GROUP BY
    d.name;
