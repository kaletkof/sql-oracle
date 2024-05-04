/* Język SQL. Rozdział 10.Kursory – zadania  */

-- 1
DECLARE
    CURSOR c_prac IS SELECT nazwisko, zatrudniony FROM pracownicy WHERE etat='ASYSTENT';
    v_nazwisko pracownicy.nazwisko%TYPE;
    v_zatrudniony pracownicy.zatrudniony%TYPE;
BEGIN
    OPEN c_prac;
    LOOP
        FETCH c_prac INTO v_nazwisko, v_zatrudniony;
        EXIT WHEN c_prac%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_nazwisko || ' pracuje od ' || TO_CHAR(v_zatrudniony, 'DD-MM-YYYY'));
    END LOOP;
    CLOSE c_prac;
END;

-- 2
DECLARE
    CURSOR c_prac IS SELECT nazwisko, placa_pod FROM pracownicy;
    v_nazwisko pracownicy.nazwisko%TYPE;
    v_placa pracownicy.placa_pod%TYPE;
BEGIN
    FOR c_rec IN c_prac LOOP
        IF c_prac%ROWCOUNT > 3 THEN
            EXIT;
        END IF;
        DBMS_OUTPUT.PUT_LINE(c_prac%ROWCOUNT || ' : ' || c_rec.nazwisko);
    END LOOP;
END;

-- 3
DECLARE
    CURSOR c IS
        SELECT nazwisko, placa_pod, zatrudniony FROM pracownicy
        WHERE to_char(zatrudniony, 'DAY') LIKE '%PONIEDZ%'
        FOR UPDATE OF placa_pod;
BEGIN
    FOR c_rec IN c LOOP
        UPDATE pracownicy SET placa_pod = 1.2 * placa_pod WHERE CURRENT OF c;
        dbms_output.put_line(c_rec.nazwisko || ' ' || to_char(c_rec.placa_pod * 1.2));
    END LOOP;
END;

-- 4
DECLARE
    CURSOR c_prac IS SELECT id_prac, nazwisko, placa_dod, nazwa, etat FROM pracownicy JOIN zespoly USING (id_zesp) FOR UPDATE OF placa_pod;
BEGIN
    FOR c_rec IN c_prac LOOP
        CASE c_rec.nazwa
            WHEN 'ALGORYTMY' THEN
                UPDATE pracownicy SET placa_dod = placa_dod + 100 WHERE CURRENT OF c_prac;
            WHEN 'ADMINISTRACJA' THEN
                UPDATE pracownicy SET placa_dod = placa_dod + 150 WHERE CURRENT OF c_prac;
            ELSE
                IF c_rec.etat='STAZYSTA' THEN
                    DELETE FROM pracownicy WHERE id_prac=c_rec.id_prac;
                END IF;
        END CASE;
    END LOOP;
END;
SELECT * FROM pracownicy JOIN zespoly USING (id_zesp);

-- 5
DECLARE
    CURSOR c (x_etat PRACOWNICY.ETAT%TYPE) IS SELECT nazwisko FROM pracownicy WHERE etat = x_etat;
    v_etat VARCHAR2(20) := '&etat';
BEGIN
    FOR c_rec IN c(v_etat) LOOP
        DBMS_OUTPUT.PUT_LINE(c_rec.nazwisko);
    END LOOP;
END;

-- 6
DECLARE
    CURSOR c (x_etat PRACOWNICY.ETAT%TYPE) IS SELECT nazwisko FROM pracownicy WHERE etat = x_etat;
    v_etat PRACOWNICY.ETAT%TYPE := '&etat';
    v_tmp PRACOWNICY.ETAT%TYPE;
BEGIN
    SELECT nazwa INTO v_tmp FROM ETATY WHERE nazwa = v_etat;
    FOR c_rec IN c(v_etat) LOOP
        DBMS_OUTPUT.PUT_LINE(c_rec.nazwisko);
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nie ma nikogo na etacie ' || v_etat);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Blad o tresci: ' || SQLERRM);
END;

-- 7
DECLARE
    ex_za_duza_podwyzka EXCEPTION;
    CURSOR c_prof IS SELECT nazwisko, id_prac, placa_pod FROM pracownicy WHERE etat = 'PROFESOR' FOR UPDATE OF placa_pod;
    v_suma pracownicy.placa_pod%TYPE;
    v_nowa_pensja pracownicy.placa_pod%TYPE;
    ex_pensja EXCEPTION;
BEGIN
    FOR c_rec IN c_prof LOOP
        SELECT SUM (placa_pod) INTO v_suma FROM pracownicy WHERE id_szefa = c_rec.id_prac;
        v_nowa_pensja := c_rec.placa_pod + 0.1 * v_suma;
        IF (v_nowa_pensja >= 2000) THEN
            RAISE ex_pensja;
        ELSE
            UPDATE pracownicy SET placa_pod = v_nowa
