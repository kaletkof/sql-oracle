/* Język SQL. Rozdział 12.Pakiety – zadania  */

-- 1
CREATE OR REPLACE PACKAGE konwersja IS
    FUNCTION CELS_TO_FAHR(cels NUMBER) RETURN FLOAT;
    FUNCTION FAHR_TO_CELS(fahr NUMBER) RETURN FLOAT;
END konwersja;

CREATE OR REPLACE PACKAGE BODY konwersja IS
    FUNCTION CELS_TO_FAHR(cels NUMBER) RETURN FLOAT IS
        wynik FLOAT;
    BEGIN
        wynik := 9/5 * cels + 32;
        RETURN wynik;
    END CELS_TO_FAHR;

    FUNCTION FAHR_TO_CELS(fahr NUMBER) RETURN FLOAT IS
        wynik FLOAT;
    BEGIN
        wynik := (fahr - 32) * 5/9;
        RETURN wynik;
    END FAHR_TO_CELS;
END konwersja;

-- 2
DECLARE
    sql_stmt VARCHAR2(128);
    srednia_placa Pracownicy.placa_pod%TYPE;
    id pracownicy.id_prac%type;
BEGIN
    sql_stmt := 'SELECT id_prac FROM pracownicy WHERE nazwisko = :1';
    EXECUTE IMMEDIATE sql_stmt INTO id USING 'BRZEZINSKI';
    
    sql_stmt := 'SELECT AVG(placa_pod) FROM pracownicy WHERE id_szefa = :id';
    EXECUTE IMMEDIATE sql_stmt INTO srednia_placa USING id;
    
    sql_stmt := 'UPDATE PRACOWNICY SET placa_dod = :sred WHERE id_prac = :id';
    EXECUTE IMMEDIATE sql_stmt USING srednia_placa, id;
END;
