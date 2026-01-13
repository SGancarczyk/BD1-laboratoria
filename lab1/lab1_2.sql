CREATE TABLE zaklady
(
    id_zakladu NUMBER(3) constraint p_k_dep PRIMARY KEY,
    name VARCHAR2(40 char) not null
);

ALTER TABLE zaklady
add constraint zaklady_pracownik_fk
foreign key (id_zakladu) references DEPARTMENTS(DEPARTMENT_ID)
