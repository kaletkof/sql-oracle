/* Język SQL. Rozdział 13.Wyzwalacze – zadania  */

-- 1
CREATE SEQUENCE seq_zesp START WITH 60 INCREMENT BY 10;

CREATE OR REPLACE TRIGGER trig_id_zesp
BEFORE INSERT ON zespoly
FOR EACH ROW
BEGIN
    IF (:NEW.id_zesp IS NULL) THEN
        SELECT seq_zesp.NEXTVAL INTO :NEW.id_zesp FROM DUAL;
    END IF;
END;

-- 2
ALTER TABLE ZESPOLY ADD (LICZBA_PRACOWNIKOW NUMBER);

UPDATE ZESPOLY Z
SET LICZBA_PRACOWNIKOW = (
    SELECT COUNT(*) FROM PRACOWNICY WHERE ID_ZESP = Z.ID_ZESP
);

CREATE OR REPLACE TRIGGER trig_liczba_prac
BEFORE INSERT ON pracownicy
FOR EACH ROW
BEGIN
    UPDATE zespoly SET liczba_pracownikow = liczba_pracownikow + 1 WHERE id_zesp = :NEW.id_zesp;
END;

-- 3
CREATE TABLE HISTORIA (
    ID_PRAC NUMBER,
    PLACA_POD NUMBER,
    ETAT VARCHAR2(20),
    ZESPOL VARCHAR2(20),
    MODYFIKACJA DATE
);

CREATE OR REPLACE TRIGGER trigger_historia
BEFORE UPDATE OR DELETE ON pracownicy
FOR EACH ROW
BEGIN
    IF DELETING THEN
        INSERT INTO historia VALUES (:OLD.id_prac, :OLD.placa_pod, :OLD.etat, (SELECT nazwa FROM zespoly WHERE id_zesp = :OLD.id_zesp), SYSDATE);
    END IF;
    
    IF (:NEW.placa_pod != :OLD.placa_pod OR :NEW.etat != :OLD.etat OR :NEW.id_zesp != :OLD.id_zesp) THEN
        INSERT INTO historia VALUES (:OLD.id_prac, :OLD.placa_pod, :OLD.etat, (SELECT nazwa FROM zespoly WHERE id_zesp = :OLD.id_zesp), SYSDATE);
    END IF;
END;

-- 4
CREATE OR REPLACE VIEW szefowie AS
SELECT nazwisko AS szef, (SELECT COUNT(*) FROM pracownicy WHERE id_szefa = p.id_prac) AS pracownicy
FROM pracownicy p;

CREATE OR REPLACE TRIGGER usun_szefa
INSTEAD OF DELETE ON szefowie
FOR EACH ROW
DECLARE
    idszefa pracownicy.id_szefa%TYPE;
BEGIN
    SELECT id_prac INTO idszefa FROM pracownicy WHERE nazwisko = :OLD.szef;
    DELETE pracownicy WHERE nazwisko = :OLD.szef OR id_szefa = idszefa;
END;
