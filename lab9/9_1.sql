begin
    NULL;
end;
/

begin
    DBMS_OUTPUT.PUT_LINE('asdnasdnkjasnd');
end;
/

begin
    insert into REGIONS(region_id, name, shortname)
        values (108, 'oceania', 'OC');
    commit;
end;
/

begin
    RAISE_APPLICATION_ERROR(-20001, 'Moj komunikat');
end;
/

