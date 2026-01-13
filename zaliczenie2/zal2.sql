CREATE OR REPLACE PROCEDURE transfer_employee_check_budget(
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
        SELECT salary, department_id
        INTO v_emp_salary, v_old_dept_id
        FROM employees
        WHERE employee_id = p_emp_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Pracownik o ID ' || p_emp_id || ' nie istnieje.');
    END;

    IF v_old_dept_id = p_target_dept_id THEN
        RAISE_APPLICATION_ERROR(-20002, 'Pracownik już pracuje w tym departamencie.');
    END IF;

    BEGIN
        SELECT year_budget, name
        INTO v_target_budget, v_dept_name
        FROM departments
        WHERE department_id = p_target_dept_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Departament docelowy o ID ' || p_target_dept_id || ' nie istnieje.');
    END;

    SELECT NVL(SUM(salary), 0)
    INTO v_current_dept_sum
    FROM employees
    WHERE department_id = p_target_dept_id;

    v_projected_cost := (v_current_dept_sum + v_emp_salary) * 12;


    IF v_target_budget IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Departament nie ma ustalonego budżetu.');
    ELSIF v_projected_cost > v_target_budget THEN
        RAISE_APPLICATION_ERROR(-20005, 'Przekroczenie budżetu. Brakuje: ' || (v_projected_cost - v_target_budget));
    END IF;

    UPDATE employees
    SET department_id = p_target_dept_id
    WHERE employee_id = p_emp_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Przetransferowano pracownika do działu ' || v_dept_name);

END;
/

BEGIN
    transfer_employee_check_budget(101, 10);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił oczekiwany błąd: ' || SQLERRM);
END;
/
