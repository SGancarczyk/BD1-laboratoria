CREATE OR REPLACE PROCEDURE change_emp_position(e_id NUMBER, e_new_position_nr NUMBER)
AS
BEGIN
    UPDATE employees
    SET position_id = e_new_position_nr
    WHERE employee_id = e_id;
    commit;
END;
/

begin
    change_emp_position(101, 101);
end;
/

create or replace procedure degrade_manager_set_new(m_id NUMBER)
as
    v_new_manager_id employees.MANAGER_ID%type;
    v_old_manager_id employees.MANAGER_ID%type;
begin
    select MANAGER_ID into v_old_manager_id from EMPLOYEES
        where EMPLOYEE_ID = m_id;

    if v_old_manager_id is not null then
        raise_application_error(-20001, 'Ten pracownik nie jest managerem.');
    end if;

    select EMPLOYEE_ID into v_new_manager_id from EMPLOYEES
    where MANAGER_ID = m_id
    order by (sysdate - BIRTH_DATE) desc
    fetch first 1 row only;

    update EMPLOYEES
    set manager_id = NULL
    where employee_id = v_new_manager_id;

    update EMPLOYEES
        set manager_id = v_new_manager_id
    where manager_id = m_id;

    update EMPLOYEES
        set manager_id = v_new_manager_id
    where employee_id = m_id;

    commit;
end;
/

begin
    degrade_manager_set_new(101)
end;
/