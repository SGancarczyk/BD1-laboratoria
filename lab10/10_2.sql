create or replace procedure avg_salary_per_department(null)
as
    cursor cr is
    select department_id, avg(SALARY) as avg_salary
    from EMPLOYEES
    where department_id is not null
    group by department_id;

    v_dept_rec cr%rowtype;

begin
    for r_dept in cr loop
        dbms_output.PUT_LINE('department id: ' ||r_dept.department_id|| ' ' || r_dept.avg_salary);


    for r_emp in (select name, surname, salary from EMPLOYEES
                    where department_id = r_dept.department_id
                    and salary > r_dept.avg_salary) loop
        dbms_output.PUT_LINE(r_emp.name || '' || r_emp.surname || ' ' ||)
        end loop;
    end loop;
end;
/

create or replace procedure max_budget_departments(p_no_dept NUMBER)
as
    cursor cr is
    select department_id, name, YEAR_BUDGET
    from DEPARTMENTS
    where department_id is not null
    order by YEAR_BUDGET desc
    fetch first p_no_dept rows only;

begin
    for r_dept in cr loop
        dbms_output.PUT_LINE(r_dept.DEPARTMENT_ID || ' ' || r_dept.name || ' ' || r_dept.year_budget);
        end loop;
end;
/

CREATE OR REPLACE PROCEDURE increase_salary_history_staff
AS
    -- Deklaracja stałej (zgodnie z poleceniem)
    c_raise_percent CONSTANT NUMBER := 1.02; -- 1.02 to podwyżka o 2%
BEGIN
    -- To jest KURSOR NIEJAWNY (pojedyncza instrukcja SQL):
    UPDATE employees
    SET salary = salary * c_raise_percent
    WHERE employee_id IN (SELECT employee_id FROM positions_history);

    -- Opcjonalnie: Wyświetl ile osób dostało podwyżkę (korzystając z atrybutu kursora niejawnego)
    DBMS_OUTPUT.PUT_LINE('Podniesiono pensję ' || SQL%ROWCOUNT || ' pracownikom.');

    COMMIT;
END;
/




