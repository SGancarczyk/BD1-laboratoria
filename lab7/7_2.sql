select e.name, e.surname, e.salary from employees e
join positions p using (position_id)
where salary not between MIN_SALARY and MAX_SALARY;

select e.name, e.surname, e.salary, d.name as department_name from (employees e
join positions p using (position_id)) join departments d using (department_id)
where salary not between MIN_SALARY and MAX_SALARY;

select d.name, e.name, e.surname from
employees e join departments d using (department_id)
where e.manager_id is null and d.YEAR_BUDGET between 5000000 and 10000000;

select d.name from departments d join addresses a using (address_id)
where a.country_id = 104;

select d.name, e.name, e.surname from
    (employees e join departments d using (department_id))
    join addresses a using(address_id)
where e.manager_id is null and ADDRESS_ID = 104 and
      d.YEAR_BUDGET between 5000000 and 10000000;


