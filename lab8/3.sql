CREATE OR REPLACE TRIGGER trg_check_budget_insert
    BEFORE INSERT ON employees
    FOR EACH ROW
DECLARE
    -- To magiczna linijka, która pozwala ominąć błąd "Mutating Table"
    PRAGMA AUTONOMOUS_TRANSACTION;

    v_dept_budget      departments.year_budget%TYPE;
    v_current_monthly_sum NUMBER;
    v_projected_annual_cost NUMBER;
BEGIN
    -- 1. Pobieramy roczny budżet departamentu, do którego trafia pracownik
    -- Jeśli departament nie istnieje lub nie ma budżetu, obsłużymy to w wyjątkach lub IF
    BEGIN
        SELECT year_budget
        INTO v_dept_budget
        FROM departments
        WHERE department_id = :NEW.department_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Opcjonalnie: Jeśli dział nie istnieje, blokujemy (lub pozwalamy, zależnie od logiki)
            RAISE_APPLICATION_ERROR(-20001, 'Błąd: Podany departament nie istnieje.');
    END;

    -- 2. Pobieramy sumę obecnych pensji w tym dziale
    -- Używamy NVL na wypadek, gdyby dział był pusty
    SELECT NVL(SUM(salary), 0)
    INTO v_current_monthly_sum
    FROM employees
    WHERE department_id = :NEW.department_id;

    -- 3. Obliczamy, ile będzie kosztował dział ROCZNIE po dodaniu nowego pracownika
    -- (Obecna suma + Nowa pensja) * 12 miesięcy
    v_projected_annual_cost := (v_current_monthly_sum + :NEW.salary) * 12;

    -- 4. Logika sprawdzająca
    IF v_dept_budget IS NOT NULL THEN
        IF v_projected_annual_cost > v_dept_budget THEN
            -- Ważne: ROLLBACK nie jest tu potrzebny, bo RAISE wycofa insert,
            -- ale przy Autonomous Transaction dobra praktyka wymaga zamknięcia transakcji odczytu.
            COMMIT;
            RAISE_APPLICATION_ERROR(-20002,
                                    'Przekroczenie budżetu! Limit: ' || v_dept_budget ||
                                    ', Przewidywany koszt: ' || v_projected_annual_cost);
        END IF;
    ELSE
        -- Opcjonalnie: Co robić, gdy budżet nie jest ustalony (jest NULL)?
        -- Tutaj: Blokujemy
        COMMIT;
        RAISE_APPLICATION_ERROR(-20003, 'Ten departament nie ma ustalonego budżetu.');
    END IF;

    -- Konieczne zamknięcie autonomicznej transakcji (nawet jeśli robiliśmy tylko SELECT)
    COMMIT;

END;
/

-- Scenariusz testowy:
BEGIN
    -- 1. Ustawmy mały budżet dla działu 60 (np. 120 000 rocznie)
    -- Żeby test był wiarygodny, upewnij się, że dział 60 istnieje.
    UPDATE departments SET year_budget = 120000 WHERE department_id = 60;
    COMMIT;


    INSERT INTO employees (employee_id, name, surname, email, date_employed, job_id, salary, department_id, manager_id)
    VALUES (999, 'Test', 'Budzetowy', 'TESTBUD', sysdate, 'IT_PROG', 15000, 60, NULL);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Przechwycono oczekiwany błąd: ' || SQLERRM);
        ROLLBACK;
END;
/