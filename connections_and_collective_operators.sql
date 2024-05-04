/* Język SQL. Rozdział 4.Połączenia i operacje zbiorowe – zadania  */

-- 1.
SELECT
    nazwisko,
    etat,
    z.id_zesp,
    nazwa
FROM
    pracownicy p,
    zespoly z
WHERE
    p.id_zesp = z.id_zesp;

-- 2.
SELECT
    nazwisko,
    etat,
    z.id_zesp,
    adres
FROM
    pracownicy p,
    zespoly z
WHERE
    p.id_zesp = z.id_zesp
    AND z.adres = 'PIOTROWO 3A'
ORDER BY
    nazwisko;

-- 3.
SELECT
    nazwisko,
    adres,
    nazwa
FROM
    pracownicy p,
    zespoly z
WHERE
    p.id_zesp = z.id_zesp
    AND p.placa_pod > 400;

-- 4.
SELECT
    nazwisko,
    placa_pod,
    nazwa AS "KAT_PLAC",
    placa_min,
    placa_max
FROM
    pracownicy,
    etaty
WHERE
    placa_pod BETWEEN placa_min AND placa_max;

-- 5.
SELECT
    nazwisko,
    etat,
    placa_pod,
    nazwa,
    placa_min,
    placa_max
FROM
    pracownicy p,
    etaty e
WHERE
    e.nazwa = 'SEKRETARKA'
    AND placa_pod BETWEEN e.placa_min AND e.placa_max;

-- 6.
SELECT
    nazwisko,
    etat,
    placa_pod,
    e.nazwa AS "Kategoria",
    z.nazwa AS "Nazwa_zespolu"
FROM
    pracownicy p,
    etaty e,
    zespoly z
WHERE
    p.etat <> 'ASYSTENT'
    AND p.id_zesp = z.id_zesp
    AND placa_pod BETWEEN e.placa_min AND e.placa_max
ORDER BY
    placa_pod DESC;

-- 7.
SELECT
    nazwisko,
    etat,
    placa_pod * 12 + NVL(placa_dod, 0) AS "ROCZNA_PLACA",
    e.nazwa
FROM
    pracownicy p,
    etaty e,
    zespoly z
WHERE
    (p.etat = 'ASYSTENT' OR p.etat = 'ADIUNKT')
    AND p.id_zesp = z.id_zesp
    AND e.nazwa = p.etat
    AND (placa_pod * 12 + NVL(placa_dod, 0)) > 5500;

-- 8.
SELECT
    p.id_prac,
    p.nazwisko,
    p.id_szefa,
    s.nazwisko
FROM
    pracownicy p,
    pracownicy s
WHERE
    p.id_szefa = s.id_prac;

-- 9.
SELECT
    p.id_prac,
    p.nazwisko,
    p.id_szefa,
    s.nazwisko
FROM
    pracownicy p,
    pracownicy s
WHERE
    p.id_szefa = s.id_prac(+);
