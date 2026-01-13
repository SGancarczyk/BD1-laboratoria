CREATE OR REPLACE PROCEDURE show_above_avg_salary IS
    CURSOR c_dept_avgs IS
        SELECT department_id, AVG(salary) as avg_sal
        FROM employees
        WHERE department_id IS NOT NULL
        GROUP BY department_id;

    v_emp_name    employees.name%TYPE;
    v_emp_surname employees.surname%TYPE;
    v_emp_salary  employees.salary%TYPE;
BEGIN
    FOR r_dept IN c_dept_avgs LOOP

            DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
            DBMS_OUTPUT.PUT_LINE('Departament ID: ' || r_dept.department_id ||
                                 ' | Średnia pensja: ' || ROUND(r_dept.avg_sal, 2));


            FOR r_emp IN (
                SELECT name, surname, salary
                FROM employees
                WHERE department_id = r_dept.department_id
                  AND salary > r_dept.avg_sal
                ) LOOP
                    DBMS_OUTPUT.PUT_LINE('   -> Pracownik: ' || r_emp.name || ' ' || r_emp.surname ||
                                         ' (Zarobki: ' || r_emp.salary || ')');
                END LOOP;

        END LOOP;
END;
/