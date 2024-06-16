--============================================--

sqlplus sys/1395@orcl as sysdba

ALTER SESSION SET CONTAINER = ORCLPDB;

DROP TABLESPACE ORACLE_USER_TBS INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;

DROP USER oracle_user;

CREATE USER oracle_user IDENTIFIED BY oracle_user;

GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE PROCEDURE TO oracle_user; 


DROP TABLESPACE  oracle_user_test INCLUDING CONTENTS AND DATAFILES;


CREATE TABLESPACE oracle_user_tbs datafile '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_test.dbf' size 3M;

ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_test.dbf' AUTOEXTEND ON NEXT 1M maxsize 20M; 

ALTER USER oracle_user DEFAULT TABLESPACE oracle_user_tbs QUOTA UNLIMITED ON oracle_user_tbs; 
ALTER USER oracle_user QUOTA UNLIMITED ON oracle_user_idx_tbs;

GRANT CREATE TABLESPACE TO oracle_user; 
GRANT SELECT ON V_$SQL TO oracle_user; 
GRANT DROP TABLESPACE TO oracle_user;

--SELECT tablespace_name, status, contents, extent_management, allocation_type, segment_space_management FROM dba_tablespaces;

--============================================--

sqlplus oracle_user/oracle_user@localhost:1521/orclpdb
    
DROP TABLESPACE oracle_user_idx_tbs INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE oracle_user_backup_tbs INCLUDING CONTENTS AND DATAFILES;


CREATE TABLESPACE oracle_user_idx_tbs
    DATAFILE '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_idx_tbs.dbf'
    SIZE 50M
    AUTOEXTEND ON
    EXTENT MANAGEMENT LOCAL
    UNIFORM SIZE 500K;

CREATE TABLESPACE oracle_user_backup_tbs 
    DATAFILE '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_backup_tbs.dbf'
    SIZE 50M
    AUTOEXTEND ON
    EXTENT MANAGEMENT LOCAL
    UNIFORM SIZE 500K;
-- Crearea tabelelor primare
CREATE TABLE angajati (
    idangajat      INTEGER NOT NULL,
    dataangajare   DATE NOT NULL,
    post           VARCHAR2(50) NOT NULL
);
ALTER TABLE angajati ADD CONSTRAINT angajati_pk PRIMARY KEY (idangajat);

CREATE TABLE fisemedicale (
    idfisamedicala    INTEGER NOT NULL,
    sex               VARCHAR2(10) NOT NULL,
    culoare           VARCHAR2(25),
    seriecip          NUMBER NOT NULL,
    greutate          NUMBER(3) NOT NULL,
    inaltime          NUMBER(3) NOT NULL,
    datanastere       DATE,
    varsta            INTEGER,
    angajati_idangajat INTEGER NOT NULL
);

ALTER TABLE fisemedicale ADD CONSTRAINT fisemedicale_pk PRIMARY KEY (idfisamedicala);

CREATE TABLE tratamente (
    idtratament       INTEGER NOT NULL,
    denumiretratament VARCHAR2(50)
);
ALTER TABLE tratamente ADD CONSTRAINT tratamente_pk PRIMARY KEY (idtratament);

CREATE TABLE situatiestocuri (
    idsituatie          INTEGER NOT NULL,
    cantitateintrare    INTEGER NOT NULL,
    cantitateconsumata  INTEGER NOT NULL,
    necesaraprovizionare INTEGER NOT NULL,
    dataprimirestoc     DATE NOT NULL
);
ALTER TABLE situatiestocuri ADD CONSTRAINT situatiestocuri_pk PRIMARY KEY (idsituatie);

CREATE TABLE stocuri (
    idstoc                      INTEGER NOT NULL,
    tipstoc                     VARCHAR2(50) NOT NULL,
    situatiestocuri_idsituatie  INTEGER NOT NULL
);
ALTER TABLE stocuri ADD CONSTRAINT stocuri_pk PRIMARY KEY (idstoc);

-- Adăugarea constrângerilor externe (foreign keys) pentru tabelele deja create
ALTER TABLE stocuri
    ADD CONSTRAINT stocuri_situatiestocuri_fk FOREIGN KEY (situatiestocuri_idsituatie)
        REFERENCES situatiestocuri (idsituatie);

CREATE TABLE tratament_stoc (
    datapreluaretratament   DATE NOT NULL,
    tratamente_idtratament  INTEGER NOT NULL,
    stocuri_idstoc          INTEGER NOT NULL
);
ALTER TABLE tratament_stoc ADD CONSTRAINT tratament_stoc_pk PRIMARY KEY (tratamente_idtratament, stocuri_idstoc);

ALTER TABLE tratament_stoc
    ADD CONSTRAINT tratament_stoc_stocuri_fk FOREIGN KEY (stocuri_idstoc)
        REFERENCES stocuri (idstoc);

ALTER TABLE tratament_stoc
    ADD CONSTRAINT tratament_stoc_tratamente_fk FOREIGN KEY (tratamente_idtratament)
        REFERENCES tratamente (idtratament);

CREATE TABLE fisamedicala_tratament (
    dataadministrare         DATE NOT NULL,
    tratamente_idtratament   INTEGER NOT NULL,
    fisemedicale_idfisamedicala INTEGER NOT NULL
);
ALTER TABLE fisamedicala_tratament ADD CONSTRAINT fisamedicala_tratament_pk PRIMARY KEY (fisemedicale_idfisamedicala, tratamente_idtratament);

ALTER TABLE fisamedicala_tratament
    ADD CONSTRAINT fisamedicala_tratament_fisemedicale_fk FOREIGN KEY (fisemedicale_idfisamedicala)
        REFERENCES fisemedicale (idfisamedicala);

ALTER TABLE fisamedicala_tratament
    ADD CONSTRAINT fisamedicala_tratament_tratamente_fk FOREIGN KEY (tratamente_idtratament)
        REFERENCES tratamente (idtratament);

-- Adăugarea constrângerilor externe (foreign keys) pentru tabelele restante
ALTER TABLE fisemedicale
    ADD CONSTRAINT fisemedicale_angajati_fk FOREIGN KEY (angajati_idangajat)
        REFERENCES angajati (idangajat);




--inserturi angajati
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(1, TO_DATE('03/02/2020','DD/MM/YYYY'),'Medic');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(2, TO_DATE('11/06/2019','DD/MM/YYYY'),'Ingrijitor');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(3, TO_DATE('23/11/2020','DD/MM/YYYY'),'Paramedic');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(4, TO_DATE('18/05/2017','DD/MM/YYYY'),'Asistent');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(5, TO_DATE('20/07/2020','DD/MM/YYYY'),'Contabil');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(6, TO_DATE('13/03/2020','DD/MM/YYYY'),'Gestionar');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(7, TO_DATE('18/05/2017','DD/MM/YYYY'),'Manager');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(8, TO_DATE('11/12/2019','DD/MM/YYYY'),'Medic');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(9, TO_DATE('24/10/2021','DD/MM/YYYY'),'Asistent');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(10, TO_DATE('19/05/2020','DD/MM/YYYY'),'Ingrijitor');
INSERT INTO ANGAJATI(idangajat,dataangajare, post) VALUES(11, TO_DATE('20/08/2021','DD/MM/YYYY'),'Medic');

BEGIN
FOR i IN 12..1000 LOOP
INSERT INTO angajati (idangajat,dataangajare, post)
    VALUES(i, TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2019-01-03','J'),TO_CHAR(DATE '2021-12-29','J'))),'J'), 'Asistent');
END LOOP;
COMMIT; 
END;

alter table angajati add nume VARCHAR2(50);
--==========================================--

--inserturi situatiestocuri
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (1,40, 15, 0,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (2,30, 30, 30,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (3,100, 52, 0,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (4,35, 11 , 19,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (5,63, 20, 0,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (6,40, 20, 10,TO_DATE('19/05/2021','DD/MM/YYYY'));
----========================----

BEGIN
FOR i IN 7..10500 LOOP
INSERT INTO situatiestocuri (idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare,dataprimirestoc)
    VALUES(i, dbms_random.value(1,100), dbms_random.value(1,100), dbms_random.value(1,100), TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2021-01-03','J'),TO_CHAR(DATE '2022-12-29','J'))),'J'));
END LOOP;
COMMIT; 
END;


--inserturi stocuri
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (1,'consumabil', 1);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (2,'consumabil', 2);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (3,'consumabil', 3);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (4,'consumabil', 4);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (5,'consumabil', 5);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (6,'consumabil', 6);

-------======================----
SELECT * FROM stocuri;
BEGIN
  FOR i IN 7..10500 LOOP
    INSERT INTO stocuri (idstoc, tipstoc, situatiestocuri_idsituatie)
    VALUES (
      i,
      CASE
        WHEN dbms_random.value(1, 3) < 2 THEN 'consumabil'
        WHEN dbms_random.value(1, 3) < 3 THEN 'durabil'
        ELSE 'perisabil'
      END,
      ROUND(dbms_random.value(1, 10500))
    );
  END LOOP;
  COMMIT;
END;

-----====================----

DECLARE
    random_n NUMBER;
    tratament VARCHAR2(50);
BEGIN
    FOR i IN 1..1000 LOOP
        random_n := TRUNC(dbms_random.value(1, 6)); -- Generează un număr aleatoriu între 1 și 5
        
        IF random_n = 1 THEN
            tratament := 'Paracetamol';
        ELSIF random_n = 2 THEN
            tratament := 'Ibuprofen';
        ELSIF random_n = 3 THEN
            tratament := 'Aspirin';
        ELSIF random_n = 4 THEN
            tratament := 'Antibiotic';
        ELSIF random_n = 5 THEN
            tratament := 'Sirop de tuse';
        ELSE
            tratament := 'Tratament necunoscut'; -- În caz că nu se potrivește nicio condiție
        END IF;
        
        -- Inserare în tabel
        INSERT INTO tratamente (
          idtratament, denumiretratament
        ) VALUES (
          i, tratament
        );
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Înregistrările au fost inserate cu succes.');
END;

SELECT * FROM fisamedicala_tratament;



----===================

SELECT * FROM FISEMEDICALE;


BEGIN
  FOR i IN 1..100000 LOOP  -- 
    INSERT INTO fisemedicale (
      idfisamedicala, sex, culoare, seriecip, greutate, inaltime, datanastere, varsta, angajati_idangajat
    ) VALUES (
      i,
      CASE
        WHEN dbms_random.value(1, 2) < 1.5 THEN 'Masculin'
        ELSE 'Feminin'
      END,
      CASE
        WHEN dbms_random.value(1, 2) < 1 THEN 'Alb'
        ELSE 'Negru'
      END,
      ROUND(dbms_random.value(100000, 999999)),
      ROUND(dbms_random.value(50, 100)),
      ROUND(dbms_random.value(150, 200)),
      TRUNC(SYSDATE - dbms_random.value(6570, 25550)), -- Date between 18 and 70 years ago
      ROUND(dbms_random.value(18, 70)),
      ROUND(dbms_random.value(501, 999)) -- Assuming there are 1000 employees
    );
  END LOOP;
  COMMIT;
END;


--inserturi fisamedicala_tratament
BEGIN
  FOR i IN 1..1000 LOOP  -- Numărul de înregistrări pe care vrei să le adaugi
    INSERT INTO fisamedicala_tratament (
      dataadministrare, tratamente_idtratament, fisemedicale_idfisamedicala
    ) VALUES (
      TRUNC(SYSDATE - dbms_random.value(0, 365)),  -- Dată aleatoare în ultimul an
      ROUND(dbms_random.value(1, 1000)),  -- Id tratament între 1 și 100 (numărul de tratamente inserate)
      ROUND(dbms_random.value(300, 2000))  -- Id fisamedicala între 1 și 200000 (numărul de înregistrări în fisamedicale)
    );
  END LOOP;
  COMMIT;
END;
SELECT * FROM fisamedicala_tratament;
---===============================

--inserturi tratament_stoc
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament, stocuri_idstoc)
VALUES (TO_DATE('16/02/2021','DD/MM/YYYY'),101, 1110);
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament, stocuri_idstoc)
VALUES (TO_DATE('16/02/2021','DD/MM/YYYY'), 102, 1111);
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament, stocuri_idstoc)
VALUES (TO_DATE('16/02/2021','DD/MM/YYYY'),103, 1112);
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament, stocuri_idstoc)
VALUES (TO_DATE('16/02/2021','DD/MM/YYYY'),104, 1113);
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament, stocuri_idstoc)
VALUES (TO_DATE('16/02/2021','DD/MM/YYYY'),105, 1114);


--============================================--


ALTER INDEX ANGAJATI_PK rebuild TABLESPACE oracle_user_idx_tbs;
ALTER INDEX FISAMEDICALA_TRATAMENT_PK rebuild TABLESPACE oracle_user_idx_tbs;
ALTER INDEX FISEMEDICALE_PK rebuild TABLESPACE oracle_user_idx_tbs;
ALTER INDEX SITUATIESTOCURI_PK rebuild TABLESPACE oracle_user_idx_tbs;
ALTER INDEX STOCURI_PK rebuild TABLESPACE oracle_user_idx_tbs;
ALTER INDEX TRATAMENTE_PK rebuild TABLESPACE oracle_user_idx_tbs;
ALTER INDEX TRATAMENT_STOC_PK REBUILD TABLESPACE oracle_user_idx_tbs;

COLUMN SEGMENT_NAME format a20
SELECT SEGMENT_NAME, tablespace_name from user_segments where segment_type = 'INDEX';

--============================================--

CREATE TABLE STOCURI_BACK_UP 
TABLESPACE oracle_user_backup_tbs AS SELECT * FROM stocuri;

CREATE TABLE tratamente_backup
TABLESPACE oracle_user_backup_tbs AS SELECT * FROM tratamente;

CREATE TABLE ANGAJATI_BACKUP
TABLESPACE oracle_user_backup_tbs AS SELECT * FROM angajati;

CREATE TABLE TRATAMENTE_STOC_BACKUP
TABLESPACE oracle_user_backup_tbs AS SELECT * FROM tratament_stoc;

CREATE TABLE FISEMEDICALE_BACKUP
TABLESPACE oracle_user_backup_tbs AS SELECT * FROM fisemedicale ;


CREATE TABLE SITUATIESTOCURI_BACKUP
TABLESPACE oracle_user_backup_tbs AS SELECT * FROM situatiestocuri ;


CREATE TABLE FISAMEDICALA_TRATAMENT_BACKUP
TABLESPACE oracle_user_backup_tbs AS SELECT * FROM fisamedicala_tratament ;

INSERT INTO ANGAJATI_BACKUP SELECT t.* FROM ANGAJATI_BACKUP t CROSS JOIN angajati_backup;

--============================================--
set arraysize 300
set autotrace traceonly
select idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare,dataprimirestoc from situatiestocuri;
drop index index_situatiestocuri_test;
Create index index_situatiestocuri_test on situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata, necesaraprovizionare,dataprimirestoc);


set arraysize 300
set autotrace traceonly
set linesize 200
select idstoc, tipstoc, situatiestocuri_idsituatie FROM stocuri;
drop index index_stocuri_test;
Create index index_stocuri_test on stocuri(idstoc,tipstoc,situatiestocuri_idsituatie);


set arraysize 300
set autotrace traceonly
set linesize 200
select idfisamedicala, seriecip,greutate from fisemedicale;
drop index index_fisemedicale_test;
create index index_fisemedicale_test on fisemedicale(idfisamedicala, seriecip,greutate);


--=======---


drop index fisemedicale_test
Create  index fisemedicale_test on fisemedicale(greutate);
set arraysize 300
set autotrace traceonly
SELECT * FROM fisemedicale WHERE greutate < 50;

drop index tratamente_test;
Create  index tratamente_test on Tratamente(Denumiretratament);
set arraysize 300
set autotrace traceonly
SELECT * From Tratamente Where Denumiretratament Like 'Paracetamol';

drop index index_situatiestocuri_test;
Create index index_situatiestocuri_test on situatiestocuri(necesaraprovizionare, idsituatie);
set arraysize 300
set autotrace traceonly
SELECT idsituatie, necesaraprovizionare FROM situatiestocuri WHERE necesaraprovizionare > 99;


drop index index_stocuri_test;
Create index index_stocuri_test on stocuri(idstoc,tipstoc);
set arraysize 300
set autotrace traceonly
select idstoc,tipstoc from stocuri where tipstoc = 'consumabil';

--===========
drop index fisemedicale_test;
drop index index_angajati_test;
drop index index_tratament_test;

create index fisemedicale_test on fisemedicale(varsta ); 
create index index_angajati_test on angajati(dataangajare, post);
create index index_tratament_test on tratamente(denumiretratament);
SELECT a.idangajat, a.dataangajare, a.post, f.idfisamedicala, f.varsta, t.denumiretratament, ft.dataadministrare
FROM angajati a
JOIN fisemedicale f ON a.idangajat = f.angajati_idangajat
JOIN fisamedicala_tratament ft ON f.idfisamedicala = ft.fisemedicale_idfisamedicala
JOIN tratamente t ON ft.tratamente_idtratament = t.idtratament
WHERE f.varsta > 66
ORDER BY f.varsta;

--------

drop index fisemedicale_test;
drop index index_angajati_test;

create index fisemedicale_test on fisemedicale(idfisamedicala,inaltime ); 
create index index_angajati_test on angajati(idangajat, dataangajare, post);
SELECT a.idangajat, a.dataangajare, a.post, f.idfisamedicala, f.sex, f.culoare, f.seriecip, f.greutate, f.inaltime, f.datanastere, f.varsta
FROM angajati a
JOIN fisemedicale f ON a.idangajat = f.angajati_idangajat
WHERE f.inaltime > 199 

-----


drop index index_tratament_test;
drop index fisemedicale_test;
drop index fisamedicala_tratament_test;

create index fisemedicale_test on fisemedicale(idfisamedicala,inaltime ); 
create index fisamedicala_tratament_test on fisamedicala_tratament(dataadministrare);
create index index_tratament_test on tratamente(denumiretratament);

SELECT f.idfisamedicala, f.sex, f.culoare, f.seriecip, f.greutate, f.inaltime, t.idtratament, t.denumiretratament, ft.dataadministrare
FROM fisemedicale f
JOIN fisamedicala_tratament ft ON f.idfisamedicala = ft.fisemedicale_idfisamedicala
JOIN tratamente t ON ft.tratamente_idtratament = t.idtratament
WHERE t.denumiretratament = 'Paracetamol'
ORDER BY ft.dataadministrare;

-- In terminal --
sqlplus / as sysdba
ALTER SESSION SET CONTAINER = CDB$ROOT;
shutdown imediate;
startup mount
alter database archivelog;


mkdir -p oracle_user_backup
cp /u01/app/oracle/oradata/ORCL/datafile/oracle_user_test.dbf oracle_user_backup/
ls -l oracle_user_backup

SELECT 'cp ' || file_name || ' oracle_user_backup'
     FROM dba_data_files 
     WHERE tablespace_name = 'ORACLE_USER_TBS';





