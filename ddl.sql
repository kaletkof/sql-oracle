/* Język SQL. Rozdział 6.DDL (Data Definition Language) – zadania  */

-- 1
CREATE TABLE projekty (
    id_projektu NUMBER(4) PRIMARY KEY,
    opis_projektu VARCHAR(20) NOT NULL UNIQUE,
    data_rozpoczecia DATE DEFAULT sysdate,
    data_zakonczenia DATE,
    fundusz NUMBER(7, 2),
    CONSTRAINT ogr_data CHECK (data_zakonczenia > data_rozpoczecia),
    CONSTRAINT ogr_fundusz CHECK (fundusz >= 0)
);

CREATE TABLE przydzialy (
    id_projektu NUMBER(4) NOT NULL,
    nr_pracownika NUMBER(4) NOT NULL,
    od DATE DEFAULT sysdate,
    do DATE,
    stawka NUMBER(7, 2) CHECK (stawka > 0),
    rola VARCHAR(20) CHECK (rola IN ('KIERUJACY', 'PROGRAMISTA', 'ANALITYK')),
    CONSTRAINT ogr_data2 CHECK (do > od),
    CONSTRAINT klucz FOREIGN KEY (id_projektu) REFERENCES projekty (id_projektu),
    CONSTRAINT klucz2 FOREIGN KEY (nr_pracownika) REFERENCES pracownicy (id_prac),
    PRIMARY KEY (id_projektu, nr_pracownika)
);

-- 2
ALTER TABLE przydzialy ADD godizny NUMBER;

-- 3
COMMENT ON TABLE projekty IS 'Lista projektów prowadzonych przez pracowników';
COMMENT ON TABLE przydzialy IS 'Informacje o przydziale poszczególnych pracowników do projektów';

-- 4
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'PRZYDZIALY';

-- 5
ALTER TABLE projekty DISABLE CONSTRAINT projekty_opis_projektu_uindex;

-- 6
ALTER TABLE projekty MODIFY opis_projektu VARCHAR(30);

-- 7
CREATE TABLE pracownicy_zespoly AS
SELECT p.nazwisko,
       p.etat AS posada,
       p.placa_pod * 12 + NVL(p.placa_dod, 0) AS roczna_placa,
       z.nazwa AS zespol,
       z.adres AS adres_pracy
FROM pracownicy p
JOIN zespoly z USING (id_zesp);
