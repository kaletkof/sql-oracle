/* Język SQL. Rozdział 4. Funkcje grupowe – zadania  */


-- 1.
SELECT
    MIN(placa_pod) AS minimum,
    MAX(placa_pod) AS maksimum,
    MAX(placa_pod) - MIN(placa_pod) AS różnica
FROM
    pracownicy;



-- 2.

SELECT
    etat,
    AVG(placa_pod) AS srednia
FROM
    pracownicy
GROUP BY
    etat
ORDER BY
    srednia DESC;



-- 3.

SELECT
    COUNT(*) AS profesorowie
FROM
    pracownicy
WHERE
    etat = 'PROFESOR';



-- 4.

SELECT
    id_zesp,
    SUM(placa_pod + nvl(placa_dod, 0)) AS sumaryczne_place
FROM
    pracownicy
GROUP BY
    id_zesp
ORDER BY
    id_zesp;



-- 5.

SELECT
    MAX(SUM(placa_pod + nvl(placa_dod, 0))) AS max_sum_plac
FROM
    pracownicy
GROUP BY
    id_zesp;



-- 6.

SELECT
    id_szefa AS id_szefa,
    MIN(placa_pod) AS minimalna
FROM
    pracownicy
WHERE
    id_szefa IS NOT NULL
GROUP BY
    id_szefa
ORDER BY
    minimalna DESC;



-- 7. 

SELECT
    id_zesp,
    COUNT(*) AS ilu_pracuje
FROM
    pracownicy
GROUP BY
    id_zesp
ORDER BY
    ilu_pracuje DESC;



-- 8.

SELECT
    id_zesp,
    COUNT(*) AS ilu_pracuje
FROM
    pracownicy
GROUP BY
    id_zesp
HAVING
    COUNT(*) > 3
ORDER BY
    ilu_pracuje DESC;



-- 9.

SELECT
    id_prac
FROM
    pracownicy
WHERE
    id_prac NOT IN (
        SELECT
            id_prac
        FROM
            pracownicy
    );



-- 10.

SELECT
    etat,
    AVG(placa_pod) AS srednia,
    COUNT(*) AS liczba
FROM
    pracownicy
WHERE
    zatrudniony > DATE '1990-01-01'
GROUP BY
    etat;



-- 11.

SELECT
    id_zesp,
    etat,
    round(AVG(placa_pod + nvl(placa_dod, 0))) AS srednia,
    round(MAX(placa_pod + nvl(placa_dod, 0))) AS maksymalna
FROM
    pracownicy
WHERE
    etat IN (
        'PROFESOR',
        'ASYSTENT'
    )
GROUP BY
    id_zesp,
    etat
ORDER BY
    id_zesp,
    etat;



-- 12.

SELECT
    EXTRACT(YEAR FROM zatrudniony) AS rok,
    COUNT(*) AS ilu_pracownikow
FROM
    pracownicy
GROUP BY
    EXTRACT(YEAR FROM zatrudniony)
ORDER BY
    rok;



-- 13.

SELECT
    length(nazwisko) AS "Ile liter",
    COUNT(*) AS "W ilu nazwiskach"
FROM
    pracownicy
GROUP BY
    length(nazwisko)
ORDER BY
    "Ile liter";



-- 14.

SELECT
    SUM(sign(instr(nazwisko, 'A') + instr(nazwisko, 'a'))) AS "Ile nazwisk z A"
FROM
    pracownicy;



-- 15.

SELECT
    SUM(sign(instr(nazwisko, 'A') + instr(nazwisko, 'a'))) AS "Ile nazwisk z A",
    SUM(sign(instr(nazwisko, 'E') + instr(nazwisko, 'e'))) AS "Ile nazwisk z E"
FROM
    pracownicy;