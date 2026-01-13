select * from EMPLOYEES e1
where e1.salary > (
    select avg(e2.salary) from employees e2
    where e1.DEPARTMENT_ID = e2.DEPARTMENT_ID
    );


select name from REGIONS r1
where NOT EXISTS(
    select r2.country_id from REG_COUNTRIES r2
        where r1.region_id = r2.region_id
);


select name from countries c
where not exists(
    select rc.country_id from reg_countries rc
        where c.country_id = rc.COUNTRY_ID
);


SELECT
    p.name,
    p.position_id
FROM
    positions p
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.position_id = p.position_id
);
