/* Język SQL. Rozdział 11.Procedury – zadania  */

-- 1
CREATE OR REPLACE PROCEDURE podwyzka (p_id_zesp IN NUMBER, p_procent IN NUMBER DEFAULT 15) IS
BEGIN
    UPDATE pracownicy 
    SET placa_pod = placa_pod + placa_pod * p_procent / 100
    WHERE id_zesp = p_id_zesp;
END podwyzka;

-- 2
CREATE OR REPLACE PROCEDURE podwyzka (p_id_zesp IN NUMBER, p_procent IN NUMBER DEFAULT 15) IS
    excBrakZesp EXCEPTION;
    tmp NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO tmp 
    FROM PRACOWNICY 
    WHERE id_zesp = p_id_zesp;
    
    IF tmp = 0 THEN
        RAISE excBrakZesp;
    END IF;
    
    UPDATE pracownicy 
    SET placa_pod = placa_pod + placa_pod * p_procent / 100
    WHERE id_zesp = p_id_zesp;
    
EXCEPTION
    WHEN excBrakZesp THEN
        dbms_output.put_line('Blad. Nie ma zespolu o id ' || to_char(p_id_zesp));
    WHEN OTHERS THEN 
        dbms_output.put_line('Wystpail inny blad');
END podwyzka;

-- 3
CREATE OR REPLACE PROCEDURE LICZBA_PRACOWNIKOW (p_zesp IN ZESPOLY.NAZWA%TYPE, p_wynik OUT NUMBER) IS
    excZlaNazwa EXCEPTION;
    tmp NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO tmp 
    FROM zespoly 
    WHERE nazwa = p_zesp;
    
    IF tmp = 0 THEN
        RAISE excZlaNazwa;
    END IF;
    
    SELECT COUNT(*) INTO p_wynik 
    FROM PRACOWNICY 
    JOIN ZESPOLY USING(id_zesp) 
    WHERE nazwa = p_zesp;
    
EXCEPTION
    WHEN excZlaNazwa THEN
        dbms_output.put_line('Blad. Nie znaleziono zespolu o nazwie ' || p_zesp);
END liczba_pracownikow;

-- 4
CREATE OR REPLACE PROCEDURE nowy_pracownik (
    p_nazwisko IN PRACOWNICY.NAZWISKO%TYPE, 
    p_zespol IN ZESPOLY.NAZWA%TYPE, 
    p_szef IN PRACOWNICY.NAZWISKO%TYPE, 
    p_placa IN PRACOWNICY.PLACA_POD%TYPE
) IS
    excBrakZespolu EXCEPTION;
    excBrakSzefa EXCEPTION;
    tmp NUMBER := 0;
    v_id_zesp PRACOWNICY.ID_ZESP%TYPE;
    v_id_szefa PRACOWNICY.ID_SZEFA%TYPE;
BEGIN
    SELECT COUNT(*) INTO tmp 
    FROM zespoly 
    WHERE nazwa = p_zespol;
    
    IF tmp = 0 THEN
        RAISE excBrakZespolu;
    END IF;
    
    SELECT COUNT(*) INTO tmp 
    FROM pracownicy 
    WHERE nazwisko = p_szef;
    
    IF tmp = 0 THEN
        RAISE excBrakSzefa;
    END IF;
    
    SELECT id_zesp INTO v_id_zesp 
    FROM zespoly 
    WHERE nazwa = p_zespol;
    
    SELECT id_prac INTO v_id_szefa 
    FROM pracownicy 
    WHERE nazwisko = p_szef;
    
    INSERT INTO pracownicy 
    VALUES (pracseq.nextVal, p_nazwisko, 'STAZYSTA', v_id_szefa, SYSDATE, p_placa, NULL, v_id_zesp);
    
EXCEPTION
    WHEN excBrakZespolu THEN
        dbms_output.put_line('Blad. Nie znaleziono zespolu o nazwie ' || p_zespol);
    WHEN excBrakSzefa THEN
        dbms_output.put_line('Blad. Nie znaleziono szefa (brak pracownika ' || p_szef || ')');
    WHEN OTHERS THEN
        dbms_output.put_line('Wystapil nieobslugiwany wyjatek');
END nowy_pracownik;

-- 5
CREATE OR REPLACE FUNCTION placa_netto (
    p_placa IN NUMBER, 
    p_podatek IN NUMBER DEFAULT 20
) RETURN NUMBER IS
    v_podatek NUMBER := p_placa - p_placa * p_podatek / 100;
BEGIN
    RETURN v_podatek;
END placa_netto;

-- 6
CREATE OR REPLACE FUNCTION silnia (n IN NUMBER) RETURN NUMBER IS
    wynik NUMBER := 1;
BEGIN
    FOR i IN 1..n LOOP
        wynik := wynik * i;
    END LOOP;
    RETURN wynik;
