/* Język SQL. Rozdział 7.DML (Data Manipulation Language) – zadania  */

-- 1
INSERT INTO PROJEKTY VALUES (1, 'INDEKSY BITMAPOWE', DATE '1999-04-02', DATE '2001-08-31', 2500);
INSERT INTO PROJEKTY VALUES (2, 'Sieci Kręgosłupowe', DATE '2000-11-12', NULL, 19000);

-- 2
INSERT INTO PRZYDZIALY VALUES (1, 170, DATE '1999-04-10', DATE '1999-05-10', 1000, 'KIERUJACY', 20);
INSERT INTO PRZYDZIALY VALUES (1, 140, DATE '2000-12-01', NULL, 1500, 'ANALITYK', 40);

-- 3
UPDATE PRZYDZIALY P
SET P.STAWKA = 1200
WHERE P.NR_PRACOWNIKA = 170;

-- 4
UPDATE PROJEKTY
SET (DATA_ZAKONCZENIA, FUNDUSZ) = (SELECT DATE '2001-12-31', 19000 FROM DUAL)
WHERE OPIS_PROJEKTU = 'INDEKSY BITMAPOWE';

-- 5
INSERT INTO PROJEKTY VALUES (3, 'INTELIGENTE STEROWANIE RUCHEM', DATE '2009-04-02', DATE '2010-08-31', 4000);
INSERT INTO PROJEKTY VALUES (4, 'WIELOPLATFORMOWE BAZY DANYCH', DATE '2010-04-02', NULL, 2100);

-- 6
DELETE FROM PROJEKTY proj
WHERE NOT EXISTS (SELECT * FROM PRZYDZIALY WHERE PROJ.ID_PROJEKTU = ID_PROJEKTU);

-- 7
CREATE TABLE kopiaPracownikow AS SELECT placa_pod, id_zesp FROM pracownicy;
UPDATE Pracownicy p
SET placa_pod = placa_pod + (SELECT avg(placa_pod) FROM kopiaPracownikow WHERE p.id_zesp = id_zesp) * 0.1;
DROP TABLE kopiaPracownikow;

-- 8
CREATE TABLE kopiaPracownikow AS SELECT placa_pod FROM pracownicy;
UPDATE Pracownicy p
SET placa_pod = (SELECT avg(placa_pod) FROM kopiaPracownikow)
WHERE p.placa_pod < (SELECT avg(placa_pod) FROM kopiaPracownikow);
DROP TABLE kopiaPracownikow;

-- 9
UPDATE Pracownicy p1
SET placa_dod = (SELECT avg(placa_pod) FROM Pracownicy p
WHERE p.id_szefa = (SELECT id_prac FROM PRACOWNICY WHERE nazwisko = 'MORZY' AND etat = 'PROFESOR'))
WHERE p1.id_zesp = 20;

-- 10
UPDATE (SELECT placa_pod, nazwa FROM pracownicy JOIN zespoly USING (id_zesp) WHERE nazwa = 'SYSTEMY ROZPROSZONE')
SET placa_pod = 1.25 * placa_pod;

-- 11
DELETE FROM (SELECT p.nazwisko AS pracownik, s.nazwisko AS szef
FROM pracownicy p JOIN pracownicy s
ON p.id_szefa = s.id_prac)
WHERE szef = 'MORZY';

-- 12
CREATE SEQUENCE myseq START WITH 300 INCREMENT BY 10;

-- 13
INSERT INTO pracownicy (id_prac, nazwisko, etat) VALUES (myseq.NEXTVAL, 'TRABCZYNSKI', 'STAZYSTA');

-- 14
UPDATE pracownicy SET placa_dod = myseq.CURRVAL WHERE nazwisko = 'TRABCZYNSKI';

-- 15
CREATE SEQUENCE malaSek MAXVALUE 2;
SELECT malaSek.NEXTVAL FROM DUAL;
SELECT malaSek.NEXTVAL FROM DUAL;
-- przekroczenie zakresu:
SELECT malaSek.NEXTVAL FROM DUAL;
SELECT malaSek.NEXTVAL FROM DUAL;
