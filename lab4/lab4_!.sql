select STATUS_ID, count(*) count from EMPLOYEES
where GENDER = 'K'
group by STATUS_ID;


select DEPARTMENT_ID, min(SALARY), max(SALARY), avg(SALARY), median(SALARY), stddev(SALARY) from EMPLOYEES
group by DEPARTMENT_ID;


select LANGUAGE, count(*), avg(POPULATION) from COUNTRIES
group by LANGUAGE
having count(*) > 1
order by count(*) desc;


select gender, avg(salary), avg(to_char(sysdate, 'YYYY') - to_char(BIRTH_DATE, 'YYYY')), avg(to_char(sysdate,'YYYY') - to_char(DATE_EMPLOYED, 'YYYY')) from EMPLOYEES
group by GENDER
having gender is not null
order by avg(SALARY) desc;


select extract(year from ESTABLISHED), count(DEPARTMENT_ID) from DEPARTMENTS
group by extract(year from ESTABLISHED);


select to_char(DATE_EMPLOYED, 'MM') as miesiac, count(*) from EMPLOYEES
group by to_char(DATE_EMPLOYED, 'MM')
having to_char(DATE_EMPLOYED, 'MM') is not null
order by miesiac;


select DEPARTMENT_ID, STATUS_ID, avg(salary) from EMPLOYEES
group by DEPARTMENT_ID, STATUS_ID
having STATUS_ID in (301, 304);

select DEPARTMENT_ID, STATUS_ID, avg(salary) from EMPLOYEES
where STATUS_ID in (301, 304)
group by DEPARTMENT_ID, STATUS_ID;
