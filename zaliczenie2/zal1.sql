create or replace function get_dept_sum(dept_id NUMBER)
    return NUMBER
AS
    v_count NUMBER;
    v_sum   NUMBER;
BEGIN

    select COUNT(*), SUM(salary)
    into v_count, v_sum
    from employees
    where department_id = dept_id;

    if v_count > 3 then
        return NVL(v_sum, 0);
    else
        return 0;
    END IF;
END;
/


select
    department_id,
    name,
    (select COUNT(*) from employees where department_id = d.department_id) as licznik_pracownikow,
    get_dept_sum(department_id) as wynik_funkcji
from departments d;


