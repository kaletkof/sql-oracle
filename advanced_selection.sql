/* Język SQL. Rozdział 3.Zaawansowana selekcja danych – zadania  */

-- 1.
SELECT
    nazwisko,
    ( substr(etat, 1, 2)
      || id_prac ) AS kod
FROM
    pracownicy;

-- 2.

SELECT
    nazwisko,
    translate(nazwisko, 'KLM', 'XXX') AS wojna_literom
FROM
    pracownicy;

-- 3.

SELECT
    nazwisko
FROM
    pracownicy
WHERE
    instr(nazwisko, 'L') BETWEEN 1 AND ( length(nazwisko) / 2 );

-- 4.

SELECT
    nazwisko,
    round(placa_pod * 1.15) AS podwyzka
FROM
    pracownicy;

-- 5.

SELECT
    nazwisko,
    placa_pod,
    ( placa_pod * 0.2 ) AS inwestycja,
    ( ( placa_pod * 0.2 ) * power(1 + 0.1, 10) ) AS kapital,
    ( ( placa_pod * 0.2 ) * power(1 + 0.1, 10) ) - ( placa_pod * 0.2 ) AS zysk
FROM
    pracownicy;

-- 6.

SELECT
    nazwisko,
    zatrudniony AS zatrudni,
    EXTRACT(YEAR FROM((DATE '2000-01-01' - zatrudniony) YEAR TO MONTH)) AS staz_w_2000
FROM
    pracownicy;

-- 7.

SELECT
    nazwisko,
    to_char(zatrudniony, 'MONTH, DD YYYY') AS data_zatrudnienia
FROM
    pracownicy
WHERE
    id_zesp = 20;

-- 8.

SELECT
    to_char(current_date, 'DAY') AS dzis
FROM
    dual;

-- 9.

SELECT
    nazwa,
    adres,
    CASE
        WHEN adres LIKE '%STRZELECKA%' THEN
            'STARE MIASTO'
        WHEN adres LIKE '%MIELZYNSKIEGO%' THEN
            'STARE MIASTO'
        WHEN adres LIKE '%PIOTROWO%' THEN
            'NOWE MIASTO'
        WHEN adres LIKE '%WLODKOWICA%' THEN
            'GRUNWALD'
    END AS dzielnica
FROM
    zespoly;

-- 10.

SELECT
    nazwisko,
    placa_pod,
    CASE
        WHEN placa_pod < 480 THEN
            'Poniżej 480'
        WHEN placa_pod = 480 THEN
            'Dokładnie 480'
        WHEN placa_pod > 480 THEN
            'Powyżej 480'
    END AS prog
FROM
    pracownicy
ORDER BY
    placa_pod DESC;

-- 11.

SELECT
    nazwisko,
    placa_pod,
    decode(sign(placa_pod - 480), - 1, 'Ponizej ', 1, 'Powyzej ',
           'Dokladnie ')
    || '480' AS próg
FROM
    pracownicy
ORDER BY
    placa_pod DESC;
