select e.name, e.surname, abs(round(e.salary - (select avg(emp.salary)
                                      from employees emp
                                      where emp.department_id = e.department_id), 2))
from employees e
where e.salary is not null;

select e.name, e.surname, abs(round(e.salary - (select avg(emp.salary)
                                                from employees emp
                                                where emp.department_id = e.department_id), 2))
from employees e
where e.salary is not null
  and e.gender = 'K'
  and abs(round(e.salary - (select avg(emp.salary)
                from employees emp
                where emp.department_id = e.department_id), 2)) > 1000;

select count(*) from (
select e.name, e.surname, abs(round(e.salary - (select avg(emp.salary)
                                                from employees emp
                                                where emp.department_id = e.department_id), 2))
from employees e
where e.salary is not null
  and e.gender = 'K'
  and abs(round(e.salary - (select avg(emp.salary)
                            from employees emp
                            where emp.department_id = e.department_id), 2)) > 1000);

select e.name, e.surname, (SELECT MAX(date_end) FROM projects)
from employees e
where e.DATE_EMPLOYED > all(
    select DATE_END
    from PROJECTS
    where date_end is not null
    );

select e.name, e.surname, (select avg(g.grade)
                           from grades g join emp_grades eg on (g.grade_id = eg.grade_id)
                           join employees emp on (emp.EMPLOYEE_ID = eg.EMPLOYEE_ID)
                           where emp.DEPARTMENT_ID = e.DEPARTMENT_ID
                           and extract(year from eg.INSPECTION_DATE) = '2019') as avg_in_department
from employees e join emp_grades empg on (e.EMPLOYEE_ID = empg.EMPLOYEE_ID)
join grades gr on (gr.grade_id = empg.grade_id)
where gr.grade > (select avg(g.grade)
                  from grades g join emp_grades eg on (g.grade_id = eg.grade_id)
                                join employees emp on (emp.EMPLOYEE_ID = eg.EMPLOYEE_ID)
                  where emp.DEPARTMENT_ID = e.DEPARTMENT_ID
                    and extract(year from eg.INSPECTION_DATE) = '2019'

    );



