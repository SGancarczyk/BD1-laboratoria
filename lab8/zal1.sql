CREATE OR REPLACE FUNCTION get_conditional_dept_sum(p_dept_id NUMBER)
    RETURN NUMBER
AS
    v_count NUMBER;      -- Zmienna na liczbę pracowników
    v_sum   NUMBER;      -- Zmienna na sumę zarobków
BEGIN
    -- 1. Pobieramy licznik (COUNT) i sumę (SUM) w jednym kroku
    SELECT COUNT(*), SUM(salary)
    INTO v_count, v_sum
    FROM employees
    WHERE department_id = p_dept_id;

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

