-- celowo zmodyfikowalem tak by wyswietlac tez imie i nazwisko a nie tylko emp_id
select EMPLOYEE_ID, e.name, e.surname, g.grade, g.DESCRIPTION from (EMPLOYEES e
join emp_grades eg using(employee_id)) join grades g using(grade_id);


select e.name, e.surname, g.grade, g.DESCRIPTION from (EMPLOYEES e
    join emp_grades eg using(employee_id)) join grades g using(grade_id)
where e.DEPARTMENT_ID in (101, 102, 103, null);

