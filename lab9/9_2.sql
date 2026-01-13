declare
    v_min_sal employees.salary%type := 6000;
    v_emp_id employees.employee_id%type :=101;
    v_real_salary employees.salary%TYPE;
    v_name  employees.name%TYPE;
    v_surname employees.surname%type;
begin
    select salary, name, surname
    into v_real_salary, v_name, v_surname
    from EMPLOYEES
    where employee_id = v_emp_id;

    if v_real_salary > v_min_sal then
        DBMS_output.put_line('Pracownik: '|| v_name|| ' ' || v_surname || ' ' || 'Zarabia: ' || v_real_salary );
    else
        DBMS_OUTPUT.put_line('Pracownik: ' || v_name || ' ' || v_surname || ' Zarabia mniej niz 6k');
    end if;
end;
/
