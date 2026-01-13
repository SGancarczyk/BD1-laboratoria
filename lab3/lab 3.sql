select name, surname from EMPLOYEES
where SALARY > 3000;


select name, surname, salary from EMPLOYEES
where SALARY between 2000 and 3000
order by salary desc;


select name, surname, salary, DATE_EMPLOYED from EMPLOYEES
where (SALARY between 2000 and 3000) and extract(year from DATE_EMPLOYED) > 2010;


select name, surname, salary, DATE_EMPLOYED from EMPLOYEES
where (SALARY between 2000 and 3000) and TO_CHAR(DATE_EMPLOYED, 'YYYY') > 2010;


select name ,surname, (SALARY*0.23) tax from EMPLOYEES
where (SALARY*0.23) < 500;


select country_id, name from COUNTRIES
where name like 'K%';


select name, surname from EMPLOYEES
where SALARY is null;


select name, surname, department_id from EMPLOYEES
where DEPARTMENT_ID not in (102,103,105);


select name, surname, NVL(salary, 0) from  EMPLOYEES;


select name, surname, salary from EMPLOYEES
where salary is not null
order by salary desc
    fetch first 5 rows only;


select name, surname, DATE_EMPLOYED  from employees
order by DATE_EMPLOYED
    fetch first 2 rows with ties;


select name, (MAX_SALARY - MIN_SALARY) as fork from POSITIONS
order by fork desc
    fetch first 2 rows with ties;


select count(name) from REGIONS
where name like 'A%';


select max(salary) from EMPLOYEES;


select count(*) from EMPLOYEES
where DEPARTMENT_ID is null;


select name, surname, DATE_EMPLOYED from EMPLOYEES
where to_char(DATE_EMPLOYED, 'YYYY') > 2010;


select DOMAIN from COUNTRIES
where COUNTRY_ID in (119, 118, 106);


select name, code from COUNTRIES
where length(CODE) = 2;


