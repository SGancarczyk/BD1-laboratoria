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