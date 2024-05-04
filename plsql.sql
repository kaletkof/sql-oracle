/* Język SQL. Rozdział 9.PLSQL – zadania  */

-- 1
SET SERVEROUTPUT ON
DECLARE
    v_tekst VARCHAR2(32) := 'Witaj świecie';
    v_liczba NUMBER(7,3) := 1000.456;
BEGIN
    dbms_output.put_line('Zmienna v_liczba: ' || to_char(v_liczba));
    dbms_output.put_line('Zmienna v_tekst: ' || v_tekst);
END;

-- 2
DECLARE
    v_tekst VARCHAR2(32) := 'Witaj świecie!';
    v_liczba DOUBLE PRECISION := 1000.456;
BEGIN
    v_tekst := v_tekst || ' Witaj nowy dniu';
    v_liczba := v_liczba + POWER(10,15);
    dbms_output.put_line('Zmienna v_liczba: ' || to_char(v_liczba));
    dbms_output.put_line('Zmienna v_tekst: ' || v_tekst);
END;

-- 3
DECLARE
    v_a FLOAT := &pierwsza_liczba;
    v_b FLOAT := &druga_liczba;
    v_sum FLOAT := v_a + v_b;
BEGIN
    dbms_output.put_line('Suma: ' || to_char(v_sum));
END;

-- 4
DECLARE
    PI CONSTANT FLOAT := 3.14;
    v_r FLOAT := &promien;
    v_pole FLOAT := PI * v_r * v_r;
    v_obwod FLOAT := 2 * PI * v_r;
BEGIN
    dbms_output.put_line('Obwód: ' || to_char(v_obwod));
    dbms_output.put_line('Pole: ' || to_char(v_pole));
END;

-- 5
DECLARE
    v_nazwisko pracownicy.nazwisko%TYPE;
    v_etat pracownicy.etat%TYPE;
BEGIN
    SELECT nazwisko, etat INTO v_nazwisko, v_etat
    FROM pracownicy WHERE placa_pod = (SELECT MAX(placa_pod) FROM pracownicy);
    dbms_output.put_line('Najlepiej zarabia pracownik ' || v_nazwisko);
    dbms_output.put_line('Pracuje on jako ' || v_etat);
END;

-- 6
DECLARE
    SUBTYPE Pieniadze IS NUMBER(9,2);
    v_nazwisko pracownicy.nazwisko%TYPE;
    v_pieniadz Pieniadze;
BEGIN
    SELECT nazwisko, 12 * placa_pod INTO v_nazwisko, v_pieniadz
    FROM pracownicy WHERE nazwisko = 'SLOWINSKI';
    dbms_output.put_line('Pracownik ' || v_nazwisko || ' zarabia rocznie ' || to_char(v_pieniadz));
END;

-- 7
DECLARE
    v_wybor CHAR := '&wybor';
BEGIN
    IF (v_wybor = 'C') THEN
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'DD-MM-YYYY'));
    ELSIF (v_wybor = 'D') THEN
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MM:SS'));
    ELSE
        DBMS_OUTPUT.PUT_LINE('niepoprawny znak');
    END IF;
END;

-- 8
DECLARE
    v_wybor CHAR := '&wybor';
BEGIN
    CASE v_wybor
        WHEN 'C' THEN
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'DD-MM-YYYY'));
        WHEN 'D' THEN
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'HH24:MM:SS'));
        ELSE
            DBMS_OUTPUT.PUT_LINE('niepoprawny znak');
    END CASE;
END;

-- 9
DECLARE
    v_sekunda NUMBER(2);
BEGIN
    v_sekunda := to_number(to_char(SYSDATE, 'SS'));
    WHILE v_sekunda <> 25 LOOP
        v_sekunda := to_number(to_char(SYSDATE, 'SS'));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Nadeszla 25 sekunda!');
END;

-- 10
DECLARE
    v_n NUMBER := &n;
    v_silnia NUMBER := 1;
BEGIN
    FOR i IN 1 .. v_n LOOP
        v_silnia := v_silnia * i;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Silnia: ' || to_char(v_silnia));
END;

-- 11
SET SERVEROUTPUT ON SIZE 2000;
DECLARE
    v_data DATE;
    v_dzien VARCHAR2(16);
BEGIN
    FOR rok IN 2001 .. 2100 LOOP
        FOR mies IN 1 .. 12 LOOP
            v_data := TO_DATE('13-' || mies || '-' || rok,'DD-MM-YYYY');
            v_dzien := to_char(v_data, 'DAY');

            IF (INSTR(v_dzien,'PIĄ
