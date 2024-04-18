/* Język SQL. Rozdział 5.Podzapytania – zadania  */

-- 1.
SELECT
    nazwisko,
    etat,
    id_zesp
FROM
    pracownicy
WHERE
    id_zesp = (SELECT id_zesp FROM pracownicy WHERE nazwisko='BRZEZINSKI');

-- 2.
SELECT
    nazwisko,
    etat,
    zatrudniony
FROM
    pracownicy
WHERE
    (sysdate - zatrudniony) = (SELECT MAX(sysdate - zatrudniony) FROM pracownicy WHERE etat = 'PROFESOR');

-- 3.
SELECT
    nazwisko,
    zatrudniony,
    id_zesp
FROM
    pracownicy
WHERE
    (id_zesp, zatrudniony) IN (SELECT id_zesp, MAX(zatrudniony) FROM pracownicy GROUP BY id_zesp)
ORDER BY
    zatrudniony;

-- 4.
SELECT
    id_zesp,
    nazwa,
    adres
FROM
    zespoly
WHERE
    id_zesp NOT IN (SELECT id_zesp FROM pracownicy GROUP BY id_zesp);

-- 5.
SELECT
    p.nazwisko,
    p.placa_pod,
    p.etat
FROM
    pracownicy p
WHERE
    p.placa_pod > (SELECT AVG(placa_pod) FROM pracownicy WHERE etat = p.etat);

-- 6.
SELECT
    p.nazwisko,
    p.placa_pod
FROM
    pracownicy p
WHERE
    p.placa_pod > (SELECT 0.75 * placa_pod FROM pracownicy WHERE id_prac = p.id_szefa);

-- 7.
SELECT
    nazwisko
FROM
    pracownicy p
WHERE
    etat = 'PROFESOR'
    AND NOT EXISTS (SELECT 1 FROM pracownicy WHERE id_szefa = p.id_prac AND etat = 'STAZYSTA');

-- 8.
SELECT
    id_zesp,
    nazwa,
    adres
FROM
    zespoly z
WHERE
    id_zesp NOT IN (SELECT id_zesp FROM pracownicy WHERE id_zesp = z.id_zesp);

-- 9.
SELECT
    id_zesp,
    (SELECT SUM(placa_pod) FROM pracownicy WHERE id_zesp = z.id_zesp) AS SUMA_PLAC
FROM
    zespoly z
WHERE
    (SELECT SUM(placa_pod) FROM pracownicy WHERE id_zesp = z.id_zesp) = (SELECT MAX(sum(placa_pod)) AS suma FROM pracownicy GROUP BY id_zesp);

-- 10.
SELECT
    nazwisko,
    placa_pod
FROM
    pracownicy p
WHERE
    3 > (SELECT COUNT(*) FROM pracownicy WHERE p.placa_pod < placa_pod)
ORDER BY
    placa_pod DESC;

-- 11.
SELECT
    EXTRACT(YEAR FROM zatrudniony) AS rok,
    COUNT(*) AS LICZBA
FROM
    pracownicy
GROUP BY
    EXTRACT(YEAR FROM zatrudniony)
ORDER BY
    LICZBA DESC;

-- 12.
SELECT
    EXTRACT(YEAR FROM zatrudniony) AS rok,
    COUNT(*) AS LICZBA
FROM
    pracownicy
HAVING
    COUNT(*) >= ALL (SELECT COUNT(*) FROM pracownicy GROUP BY EXTRACT(YEAR FROM zatrudniony))
GROUP BY
    EXTRACT(YEAR FROM zatrudniony);

-- 13.
SELECT
    p.nazwisko,
    p.etat,
    p.nazwisko,
    p.placa_pod,
    z.nazwa
FROM
    pracownicy p
NATURAL JOIN
    zespoly z
WHERE
    p.placa_pod < (SELECT AVG(placa_pod) FROM pracownicy WHERE etat = p.etat);

-- 14.
SELECT
    p.nazwisko,
    p.etat,
    p.nazwisko,
    p.placa_pod,
    (SELECT AVG(placa_pod) FROM pracownicy WHERE etat = p.etat) AS "SREDNIA"
FROM
    pracownicy p
NATURAL JOIN
    zespoly z
WHERE
    p.placa_pod < (SELECT AVG(placa_pod) FROM pracownicy WHERE etat = p.etat);

-- 15.
SELECT
    nazwisko,
    (SELECT COUNT(*) FROM pracownicy WHERE id_szefa = p.id_prac) AS podwladni
FROM
    pracownicy p
NATURAL JOIN
    zespoly z
WHERE
    etat = 'PROFESOR' AND z.adres LIKE '%PIOTROWO%';

-- 16.
SELECT
    nazwisko,
    (SELECT AVG(placa_pod) FROM pracownicy WHERE id_zesp = p.id_zesp) AS srednia,
    (SELECT MAX(placa_pod) FROM pracownicy) AS maksymalna
FROM
    pracownicy p
WHERE
    etat = 'PROFESOR';

-- 17.
SELECT
    nazwisko,
    (SELECT nazwa FROM zespoly WHERE id_zesp = p.id_zesp) AS zespol
FROM
    pracownicy p;

-- 18.
WITH asystenci AS (
    SELECT * FROM pracownicy WHERE etat = 'ASYSTENT'
), piotrowo AS (
    SELECT * FROM zespoly WHERE adres LIKE '%PIOTROWO%'
)
SELECT
    nazwisko,
    etat,
    nazwa,
    adres
FROM
    ASYSTENCI NATURAL JOIN PIOTROWO;

-- 19.
SELECT
    nazwisko,
    id_prac,
    id_szefa,
    LEVEL
FROM
    pracownicy
CONNECT BY
    PRIOR id_prac = id_szefa
START WITH
    nazwisko = 'BRZEZINSKI';
