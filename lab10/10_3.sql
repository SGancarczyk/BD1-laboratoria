
--1 zadanie
CREATE OR REPLACE TRIGGER trg_show_tax_on_update
    BEFORE UPDATE OF salary ON employees
    FOR EACH ROW
BEGIN
    -- Obliczamy i wyświetlamy podatek od NOWEJ pensji (:NEW.salary)
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Aktualizacja pracownika: ' || :OLD.name || ' ' || :OLD.surname);
    DBMS_OUTPUT.PUT_LINE('Stara pensja: ' || :OLD.salary);
    DBMS_OUTPUT.PUT_LINE('Nowa pensja: ' || :NEW.salary);
    DBMS_OUTPUT.PUT_LINE('>> Podatek do zapłaty (20%): ' || (:NEW.salary * 0.20));
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
END;
/

SET SERVEROUTPUT ON;

BEGIN
    -- Zmieniamy pensję pracownikowi o ID 100 na 10 000
    UPDATE employees
    SET salary = 10000
    WHERE employee_id = 100;

    -- Możemy cofnąć zmianę, żeby nie psuć danych testowych
    ROLLBACK;
END;
/

-- 2 zadanie
CREATE OR REPLACE TRIGGER trg_display_avg_salary
    AFTER INSERT OR DELETE OR UPDATE OF salary ON employees
-- Brak "FOR EACH ROW" oznacza trigger na poziomie instrukcji (wykona się raz na całe zapytanie)
DECLARE
    v_avg_salary NUMBER;
BEGIN
    SELECT AVG(salary) INTO v_avg_salary FROM employees;
    DBMS_OUTPUT.PUT_LINE('Aktualna średnia zarobków w firmie: ' || ROUND(v_avg_salary, 2));
END;
/

BEGIN
    -- Podwyżka dla pracownika 100
    UPDATE employees SET salary = salary + 100 WHERE employee_id = 100;
END;
/

-- 3 zadanie
CREATE OR REPLACE TRIGGER trg_assign_manager_with_when
    BEFORE INSERT ON employees
    FOR EACH ROW
    WHEN (NEW.manager_id IS NULL AND NEW.department_id IS NOT NULL) -- Warunek w nagłówku
DECLARE
    v_dept_manager_id employees.manager_id%TYPE;
BEGIN
    -- Pobieramy szefa departamentu, do którego trafia pracownik
    SELECT manager_id INTO v_dept_manager_id
    FROM departments
    WHERE department_id = :NEW.department_id;

    -- Przypisujemy go nowemu pracownikowi
    :NEW.manager_id := v_dept_manager_id;

    DBMS_OUTPUT.PUT_LINE('Automatycznie przypisano managera ID: ' || v_dept_manager_id);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Podany departament nie ma szefa, pracownik pozostaje bez managera.');
END;
/

INSERT INTO employees (employee_id, name, surname, mail, date_employed, job_id, salary, department_id, manager_id)
VALUES (998, 'Jan', 'Bezszefa', 'JB1', sysdate, 'IT_PROG', 4000, 60, NULL);
-- Zakładając że Dept 60 (IT) istnieje i ma szefa.

--4 zadanie
CREATE OR REPLACE TRIGGER trg_assign_manager_no_when
    BEFORE INSERT ON employees
    FOR EACH ROW
DECLARE
    v_dept_manager_id employees.manager_id%TYPE;
BEGIN
    -- Warunek IF zamiast klauzuli WHEN
    IF :NEW.manager_id IS NULL AND :NEW.department_id IS NOT NULL THEN

        BEGIN
            SELECT manager_id INTO v_dept_manager_id
            FROM departments
            WHERE department_id = :NEW.department_id;

            :NEW.manager_id := v_dept_manager_id;
            DBMS_OUTPUT.PUT_LINE('Automatycznie przypisano managera (metoda IF): ' || v_dept_manager_id);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL; -- Ignorujemy błąd, jeśli dział nie ma szefa
        END;

    END IF;
END;
/

--5 zadanie
CREATE OR REPLACE TRIGGER trg_one_president_guard
    BEFORE INSERT OR UPDATE OF job_id ON employees
    FOR EACH ROW
DECLARE
    v_pres_count NUMBER;
    -- Tutaj wpisz ID stanowiska Prezesa w Twojej bazie
    c_president_job_id CONSTANT VARCHAR2(10) := 'AD_PRES';
BEGIN
    -- Sprawdzamy tylko, jeśli ktoś próbuje zostać prezesem
    IF :NEW.job_id = c_president_job_id THEN

        -- Liczymy ilu jest JUŻ prezesów
        SELECT COUNT(*) INTO v_pres_count
        FROM employees
        WHERE job_id = c_president_job_id;

        -- Jeśli już jest chociaż jeden (i nie jest to aktualizacja tego samego rekordu)
        IF v_pres_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20000, 'Błąd! W firmie może być tylko jeden Prezes (Highlander Rule).');
        END IF;

    END IF;
END;
/

BEGIN
    -- Próba awansu pracownika 105 na Prezesa (powinna zakończyć się błędem)
    UPDATE employees SET job_id = 'AD_PRES' WHERE employee_id = 105;
END;
/