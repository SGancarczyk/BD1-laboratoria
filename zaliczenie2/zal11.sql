CREATE OR REPLACE FUNCTION get_conditional_dept_sum(dept_id NUMBER)
    RETURN NUMBER
AS
    v_count NUMBER;
    v_sum   NUMBER;
BEGIN

    SELECT COUNT(*), SUM(salary)
    INTO v_count, v_sum
    FROM employees
    WHERE department_id = dept_id;

    IF v_count > 3 THEN
        RETURN NVL(v_sum, 0);
    ELSE
        RETURN 0;
    END IF;
END;
/


SELECT
    department_id,
    name,
    (SELECT COUNT(*) FROM employees WHERE department_id = d.department_id) as licznik_pracownikow,
    get_conditional_dept_sum(department_id) AS wynik_funkcji
FROM departments d;


