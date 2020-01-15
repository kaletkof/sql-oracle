/* Język SQL. Rozdział 2. Proste zapytania – zadania */



-- 1.

SELECT
    id_zesp,
    nazwa,
    adres
FROM
    zespoly;




-- 2.

SELECT
    id_prac,
    nazwisko,
    etat,
    id_szefa,
    zatrudniony,
    placa_pod,
    placa_dod,
    id_zesp
FROM
    pracownicy;



-- 3.

SELECT
    nazwisko,
    placa_pod * 12 AS roczne_dochody
FROM
    pracownicy;



-- 4.

SELECT
    etat,
    placa_pod + coalesce(placa_dod, 0) AS miesieczne_zarobki
FROM
    pracownicy;



-- 5.

SELECT
    id_zesp,
    nazwa,
    adres
FROM
    zespoly
ORDER BY
    nazwa;



-- 6. 

SELECT DISTINCT
    etat
FROM
    pracownicy
ORDER BY
    etat;



-- 7.

SELECT
    id_prac,
    nazwisko,
    etat,
    id_szefa,
    zatrudniony,
    placa_pod,
    placa_dod,
    id_zesp
FROM
    pracownicy
WHERE
    etat = 'ASYSTENT';



-- 8.

SELECT
    id_prac,
    nazwisko,
    etat,
    placa_pod,
    id_zesp
FROM
    pracownicy
WHERE
    id_zesp = 30
    OR id_zesp = 40
ORDER BY
    placa_pod DESC;



-- 9. 

SELECT
    nazwisko,
    id_zesp,
    placa_pod
FROM
    pracownicy
WHERE
    placa_pod BETWEEN 300 AND 800;



-- 10.

SELECT
    nazwisko,
    etat,
    id_zesp
FROM
    pracownicy
WHERE
    nazwisko LIKE '%SKI';



-- 11.

SELECT
    id_prac,
    id_szefa,
    nazwisko,
    placa_pod
FROM
    pracownicy
WHERE
    placa_pod > 1000
    AND id_szefa IS NOT NULL;



-- 12.

SELECT
    nazwisko,
    id_zesp
FROM
    pracownicy
WHERE
    id_zesp = 20
    AND ( nazwisko LIKE 'M%'
          OR nazwisko LIKE '%SKI' );



-- 13.

SELECT
    nazwisko,
    etat,
    ( placa_pod / 160 ) AS stawka
FROM
    pracownicy
WHERE
    etat NOT IN (
        'ADIUNKT',
        'ASYSTENT',
        'STAZYSTA'
    )
    AND ( placa_pod NOT BETWEEN 400 AND 800 )
ORDER BY
    stawka;



-- 14.

SELECT
    nazwisko,
    etat,
    placa_pod,
    placa_dod
FROM
    pracownicy
WHERE
    placa_pod + nvl(placa_dod, 0) > 1000
ORDER BY
    etat,
    nazwisko;



-- 15.

SELECT
    nazwisko
    || ' PRACUJE OD '
    || zatrudniony
    || ' I ZARABIA '
    || placa_pod AS profesorowie
FROM
    pracownicy
WHERE
    etat = 'PROFESOR';