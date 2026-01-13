create table szkolenia(
    szkolenie_id NUMBER(3) constraint number_id_pk PRIMARY KEY,
    nazwa VARCHAR2(40 CHAR) not null
);

create table pracownicy(
    emp_id NUMBER(3) constraint emp_id_pk PRIMARY KEY,
    name varchar2(40 char) not null,
    surname varchar2(40 char) not null,
    data_zatrudnienia DATE DEFAULT SYSDATE,
    szkolenie_id NUMBER(3)
);

alter table pracownicy
add constraint szkolenia_pracownicy_f_K
foreign key (szkolenie_id) references szkolenia(szkolenie_id);

alter table pracownicy
drop column data_zatrudnienia;


DROP TABLE szkolenia;