/* Język SQL. Rozdział 8.Perspektywy – zadania  */

-- 1
CREATE OR REPLACE VIEW asystenci
(id, nazwisko, placa, lata_pracy)
AS
SELECT id_prac, nazwisko, placa_pod, ROUND(MONTHS_BETWEEN(sysdate, zatrudniony) / 12)
FROM pracownicy
WHERE etat = 'ASYSTENT';

-- 2
CREATE OR REPLACE VIEW place
(id_zesp, srednia, minimum, maximum, fundusz, l_pensji, l_dodatkow)
AS
SELECT id_zesp, AVG(placa_pod), MIN(placa_pod + NVL(placa_dod, 0)), MAX(placa_pod + NVL(placa_dod, 0)),
       SUM(placa_pod + NVL(placa_dod, 0)), COUNT(placa_pod), COUNT(placa_dod)
FROM zespoly z JOIN pracownicy p USING (id_zesp)
GROUP BY id_zesp
ORDER BY id_zesp;

SELECT * FROM place;

-- 3
SELECT pr.nazwisko, pr.placa_pod
FROM pracownicy pr JOIN place pl USING (id_zesp)
WHERE pr.placa_pod < pl.srednia;

-- 4
CREATE OR REPLACE VIEW place_minimalne
(id_prac, nazwisko, etat, placa_pod)
AS
SELECT id_prac, nazwisko, etat, placa_pod
FROM pracownicy WHERE placa_pod < 500
WITH CHECK OPTION CONSTRAINT za_wysoka_placa;

SELECT * FROM place_minimalne;

-- 5
UPDATE place_minimalne
SET placa_pod = 700 WHERE nazwisko = 'HAPKE';

-- 6
CREATE OR REPLACE VIEW prac_szef
(id_prac, id_szefa, pracownik, etat, szef)
AS
SELECT id_prac, id_szefa, nazwisko, etat, (SELECT nazwisko FROM pracownicy p2 WHERE p2.id_prac = p1.id_szefa)
FROM pracownicy p1
WHERE id_szefa IS NOT NULL;

SELECT * FROM prac_szef;

-- 7
CREATE OR REPLACE VIEW zarobki
(id_prac, nazwisko, etat, placa_pod)
AS
SELECT id_prac, nazwisko, etat, placa_pod
FROM pracownicy p1
WHERE p1.placa_pod < (SELECT placa_pod FROM pracownicy p2 WHERE p2.id_prac = p1.id_szefa)
WITH CHECK OPTION CONSTRAINT placa_szefa;

SELECT * FROM zarobki;

-- 8
SELECT COLUMN_NAME, UPDATABLE, INSERTABLE, DELETABLE
FROM USER_UPDATABLE_COLUMNS
WHERE TABLE_NAME = 'PRAC_SZEF';

-- 9
SELECT nazwisko, placa_pod
FROM (
    SELECT nazwisko, placa_pod
    FROM pracownicy
    ORDER BY placa_pod DESC
)
WHERE ROWNUM <= 3;

-- 10
SELECT rnum, nazwisko, placa_pod, etat
FROM (
    SELECT ROWNUM AS rnum, nazwisko, placa_pod, etat
    FROM (
        SELECT ROWNUM, nazwisko, placa_pod, etat
        FROM pracownicy
        ORDER BY placa_pod DESC
    )
    WHERE rownum <= 10
)
WHERE rnum >= 5;
