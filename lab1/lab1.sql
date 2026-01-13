
CREATE TABLE REGIONY
(
    region_id NUMBER(3) constraint id_primarykey PRIMARY KEY,
    name VARCHAR2(40) not null,
    shortname CHAR(2) not null
);
CREATE TABLE KRAJE(
                      country_id NUMBER(3) constraint id_country PRIMARY KEY,
                      name VARCHAR2(40 CHAR) not null,
                      capital VARCHAR(40 char) not null,
                      population NUMBER(7, 2) not null,
                      language VARCHAR2(40 CHAR) not null,
                      region_id NUMBER(3),
                      CONSTRAINT klucz_obcy FOREIGN KEY (region_id) references REGIONY(region_id)
);
CREATE TABLE stanowiska
(
    -- 1. Identyfikator (Klucz Główny)
    id_stanowiska    VARCHAR2(10) CONSTRAINT stanowiska_pk PRIMARY KEY,

    -- 2. Nazwa stanowiska (tekst do 40 znaków, wymagany)
    nazwa_stanowiska VARCHAR2(40) NOT NULL,

    -- 3. Płace (liczby, np. do 999999.99)
    placa_min        NUMBER(8, 2),
    placa_max        NUMBER(8, 2),

    -- 4. Ograniczenie wielokolumnowe (Table Level Constraint)
    -- Sprawdza, czy płaca minimalna jest faktycznie mniejsza od maksymalnej
    CONSTRAINT poprawnosc_plac_chk CHECK (placa_min < placa_max)
);