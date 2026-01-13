CREATE OR REPLACE PROCEDURE transfer_employee_check_budget(
    p_emp_id NUMBER,
    p_target_dept_id NUMBER
)
AS
    -- Zmienne do przechowywania danych pracownika
    v_emp_salary      employees.salary%TYPE;
    v_old_dept_id     employees.department_id%TYPE;

    -- Zmienne do przechowywania danych departamentu i budżetu
    v_target_budget   departments.year_budget%TYPE;
    v_dept_name       departments.department_name%TYPE;
    v_current_dept_sum NUMBER;
    v_projected_cost   NUMBER;

BEGIN
    -- KROK 1: Weryfikacja pracownika (czy istnieje + pobranie jego danych)
    BEGIN
        SELECT salary, department_id
        INTO v_emp_salary, v_old_dept_id
        FROM employees
        WHERE employee_id = p_emp_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Błąd: Pracownik o ID ' || p_emp_id || ' nie istnieje.');
    END;

    -- KROK 2: Weryfikacja czy pracownik już tam nie pracuje
    IF v_old_dept_id = p_target_dept_id THEN
        RAISE_APPLICATION_ERROR(-20002, 'Błąd: Pracownik już pracuje w tym departamencie.');
    END IF;

    -- KROK 3: Weryfikacja departamentu docelowego (czy istnieje + pobranie budżetu)
    BEGIN
        SELECT year_budget, department_name
        INTO v_target_budget, v_dept_name
        FROM departments
        WHERE department_id = p_target_dept_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Błąd: Departament docelowy o ID ' || p_target_dept_id || ' nie istnieje.');
    END;

    -- KROK 4: Obliczenie aktualnego zużycia budżetu w docelowym dziale
    -- Używamy NVL, bo jeśli w dziale nikogo nie ma, SUM zwróci NULL -> zamieniamy na 0
    SELECT NVL(SUM(salary), 0)
    INTO v_current_dept_sum
    FROM employees
    WHERE department_id = p_target_dept_id;

    -- KROK 5: Symulacja przyszłych kosztów ROCZNYCH
    -- (Suma obecnych pensji + pensja nowego pracownika) * 12 miesięcy
    v_projected_cost := (v_current_dept_sum + v_emp_salary) * 12;

    -- Logowanie dla celów testowych (możesz usunąć w produkcji)
    DBMS_OUTPUT.PUT_LINE('Budżet roczny działu: ' || v_target_budget);
    DBMS_OUTPUT.PUT_LINE('Przewidywany koszt roczny po transferze: ' || v_projected_cost);

    -- KROK 6: Ostateczna weryfikacja budżetu
    -- Jeśli budżet jest NULL (nieustalony), uznajemy że nie można transferować (lub można - zależy od polityki firmy. Tu zakładam blokadę).
    IF v_target_budget IS NULL THEN
        RAISE_APPLICATION_ERROR(-20004, 'Błąd: Departament nie ma ustalonego budżetu.');
    ELSIF v_projected_cost > v_target_budget THEN
        RAISE_APPLICATION_ERROR(-20005, 'Błąd: Przekroczenie budżetu! Brakuje: ' || (v_projected_cost - v_target_budget));
    END IF;

    -- KROK 7: Jeśli doszliśmy tutaj, wszystko jest OK -> Aktualizacja
    UPDATE employees
    SET department_id = p_target_dept_id
    WHERE employee_id = p_emp_id;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Sukces: Przetransferowano pracownika do działu ' || v_dept_name);

END;
/

BEGIN
    -- 1. Przypadek pozytywny (zakładając, że budżet pozwoli)
    -- transfer_employee_check_budget(100, 60);

    -- 2. Przypadek negatywny - ten sam dział
    -- transfer_employee_check_budget(100, 90); -- Zakładając że 100 jest w 90

    -- 3. Przypadek negatywny - przekroczenie budżetu
    -- Najpierw upewnij się, że dział ma mały budżet, albo pracownik ogromną pensję
    transfer_employee_check_budget(100, 10);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił oczekiwany błąd: ' || SQLERRM);
END;
/
