create or replace procedure transfer_employee_check_budget(
    p_emp_id NUMBER,
    p_target_dept_id NUMBER
)
AS
    v_emp_salary      employees.salary%TYPE;
    v_old_dept_id     employees.department_id%TYPE;

    v_target_budget   departments.year_budget%TYPE;
    v_dept_name       departments.name%TYPE;
    v_current_dept_sum NUMBER;
    v_projected_cost   NUMBER;

BEGIN

    BEGIN
        select salary, department_id
        into v_emp_salary, v_old_dept_id
        from employees
        where employee_id = p_emp_id;
    EXCEPTION
        when NO_DATA_FOUND then
            RAISE_APPLICATION_ERROR(-20001, 'Pracownik o ID ' || p_emp_id || ' nie istnieje.');
    END;

    if v_old_dept_id = p_target_dept_id then
        RAISE_APPLICATION_ERROR(-20002, 'Pracownik już pracuje w tym departamencie.');
    end if;

    BEGIN
        select year_budget, name
        into v_target_budget, v_dept_name
        from departments
        where department_id = p_target_dept_id;
    EXCEPTION
        when NO_DATA_FOUND then
            RAISE_APPLICATION_ERROR(-20003, 'Departament docelowy o ID ' || p_target_dept_id || ' nie istnieje.');
    END;

    select NVL(SUM(salary), 0)
    into v_current_dept_sum
    from employees
    where department_id = p_target_dept_id;

    v_projected_cost := (v_current_dept_sum + v_emp_salary) * 12;


    if v_target_budget is null then
        RAISE_APPLICATION_ERROR(-20004, 'Departament nie ma ustalonego budżetu.');
    elsif v_projected_cost > v_target_budget then
        RAISE_APPLICATION_ERROR(-20005, 'Przekroczenie budżetu, brakuje: ' || (v_projected_cost - v_target_budget));
    END IF;

    update employees
    set department_id = p_target_dept_id
    where employee_id = p_emp_id;

    commit;
    DBMS_OUTPUT.PUT_LINE('Przetransferowano pracownika do działu ' || v_dept_name);

END;
/

BEGIN
    transfer_employee_check_budget(101, 101);

EXCEPTION
    when others then
        DBMS_OUTPUT.PUT_LINE('Wystąpił oczekiwany błąd: ' || SQLERRM);
END;
/
