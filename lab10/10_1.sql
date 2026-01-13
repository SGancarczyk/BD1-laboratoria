create or replace package emp_management
as
    FUNCTION create_base_login(emp_id NUMBER) return varchar2;
end;
/
create or replace package body emp_management
as

    function create_base_login(emp_id NUMBER) return varchar2
    as
        v_name employees.NAME%type;
        v_surname employees.SURNAME%type;
        v_login varchar2(50);
    begin
        select name, surname into v_name, v_surname from EMPLOYEES
        where EMPLOYEE_ID = emp_id;

        if length(v_surname) >= 7 then
            v_login := substr(v_name, 1, 1) || substr(v_surname, 1, 7);
        else
            v_login := substr(v_name, 1, 1) || v_surname;
        end if;
        return v_login;
    end create_base_login;
end emp_management;
/


