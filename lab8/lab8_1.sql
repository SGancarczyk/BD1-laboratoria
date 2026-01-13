select name, surname from EMPLOYEES
where DATE_EMPLOYED > ALL(
    select date_end from PROJECTS
    where date_end is not null
    );


select name, surname from EMPLOYEES
where DATE_EMPLOYED > (
    select max(date_end) from PROJECTS

);


select e1.name, e1.surname from EMPLOYEES e1
where e1.SALARY > 4*(
    select min(e2.salary) from employees e2
    );


select name, surname from EMPLOYEES
where DEPARTMENT_ID in (
    select d.department_id from departments d
    join addresses using(address_id)
                           where COUNTRY_ID = 104
    );







