--Funkcje

create or replace function calculate_emp_tax(p_id NUMBER)
return number
as
    v_salary employees.salary%type;
begin
    select SALARY
    into v_salary
    from EMPLOYEES
    where EMPLOYEE_ID = p_id;

    if 12 * v_salary > 100000 then
        return 0.15 * 100000 + ((v_salary*12 - 100000)*0.25);
    else
        return 0.15 * v_salary;
    end if;
end;
/

create or replace function calculate_manager_bonus(p_id NUMBER)
return number
as
    v_manager_salary employees.salary%type;
    v_nr_emp_under_manager NUMBER;
begin
    select count(*)
    into v_nr_emp_under_manager
    from EMPLOYEES
    where MANAGER_ID = p_id;

    select SALARY
    into v_manager_salary
    from EMPLOYEES
    where EMPLOYEE_ID = p_id;

    if v_nr_emp_under_manager >= 5 then
        return 0.5*v_manager_salary;
    elsif v_nr_emp_under_manager = 0 then
        return 0;
    else
        return v_nr_emp_under_manager/10*v_manager_salary;
    end if;
end;
/



