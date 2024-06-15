--============================================--

sqlplus sys/1395@orcl as sysdba

ALTER SESSION SET CONTAINER = ORCLPDB;

DROP TABLESPACE ORACLE_USER_TBS INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;

CREATE USER oracle_user IDENTIFIED BY oracle_user;

GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW, CREATE PROCEDURE TO oracle_user; 

CREATE TABLESPACE oracle_user_tbs datafile '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_test.dbf' size 3M;

ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_test.dbf' AUTOEXTEND ON NEXT 1M maxsize 20M; 

ALTER USER oracle_user DEFAULT TABLESPACE oracle_user_tbs QUOTA UNLIMITED ON oracle_user_tbs; 

GRANT CREATE TABLESPACE TO oracle_user; 
GRANT SELECT ON V_$SQL TO oracle_user; 

--SELECT tablespace_name, status, contents, extent_management, allocation_type, segment_space_management FROM dba_tablespaces;



--============================================--
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
    seriecip          INTEGER NOT NULL,
    greutate          NUMBER(2) NOT NULL,
    inaltime          NUMBER(2) NOT NULL,
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

--============================================--

--INSERTURI ANGAJATI
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

--inserturi fisa_mediacala
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta,angajati_idangajat)
VALUES(11,'M','negru',178342,10.4,0.50,null,null,1); 
INSERT INTO FISEMEDICALE (idfisamedicala,sex,culoare,seriecip,greutate,inaltime ,datanastere,varsta, angajati_idangajat) VALUES (12,'F',null,178344,20.1,0.64,TO_DATE('07/03/2019','DD/MM/YYYY'),2,11);
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta, angajati_idangajat) VALUES(13,'M','alb',178346,25.7,0.58,TO_DATE('20/05/2019','DD/MM/YYYY'),2,8);
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta, angajati_idangajat) VALUES(14,'M','bej',178348,22.7,0.45,null,null,11);
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta, angajati_idangajat) VALUES(15,'F',null,174245,0.5,0.20,TO_DATE('13/10/2017','DD/MM/YYYY'),5,8);
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta, angajati_idangajat) VALUES(16,'M','alb',178300,6,0.40,null,null,1);
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta, angajati_idangajat) VALUES(17,'F',null,12432,7.5,0.45,TO_DATE('20/05/2019','DD/MM/YYYY'),2,1);
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta, angajati_idangajat) VALUES(18,'F','maro',166445,0.5,0.20,null,null,11);
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta, angajati_idangajat) VALUES(19,'F',null,156945,0.5,0.20,TO_DATE('05/01/2020','DD/MM/YYYY'),1,8);
INSERT INTO FISEMEDICALE(idfisamedicala,sex,culoare,seriecip,greutate,inaltime,datanastere,varsta, angajati_idangajat) VALUES(20,'M','negru',17230,30,0.56,null,null,11);

--inserturi fisamedicata_tratament
INSERT INTO fisamedicala_tratament(dataadministrare,tratamente_idtratament, fisemedicale_idfisamedicala) VALUES(TO_DATE('16/06/2020','DD/MM/YYYY'),101,11);
INSERT INTO fisamedicala_tratament(dataadministrare,tratamente_idtratament, fisemedicale_idfisamedicala) VALUES(TO_DATE('16/06/2020','DD/MM/YYYY'),103,15);
INSERT INTO fisamedicala_tratament(dataadministrare,tratamente_idtratament, fisemedicale_idfisamedicala) VALUES(TO_DATE('16/06/2020','DD/MM/YYYY'),103,18);
INSERT INTO fisamedicala_tratament(dataadministrare,tratamente_idtratament, fisemedicale_idfisamedicala) VALUES(TO_DATE('16/06/2020','DD/MM/YYYY'),110,17);
INSERT INTO fisamedicala_tratament(dataadministrare,tratamente_idtratament, fisemedicale_idfisamedicala) VALUES(TO_DATE('16/06/2020','DD/MM/YYYY'),105,12);
INSERT INTO fisamedicala_tratament(dataadministrare,tratamente_idtratament, fisemedicale_idfisamedicala) VALUES(TO_DATE('16/06/2020','DD/MM/YYYY'),107,13);
INSERT INTO fisamedicala_tratament(dataadministrare,tratamente_idtratament, fisemedicale_idfisamedicala) VALUES(TO_DATE('16/06/2020','DD/MM/YYYY'),107,16);

--insert tratamente
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (101,'Purevax RCPCh FeLV');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (102,'Purevax RCPCh');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (103,'Purevax RCP');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (104,'RABISIN 1 doz?');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (105,'EURICAN DAPPi L Multi');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (106,'EURICAN DAPPi T Multi');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (107,'EURICAN L Multi');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (108,'EURICAN DAPPi');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (109,'RABISIN 10 doze');
INSERT INTO tratamente (idtratament,denumiretratament) VALUES (110,'PRIMODOG');

--inserturi tratament_stoc
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament,stocuri_idstoc) VALUES (TO_DATE('16/06/2020','DD/MM/YYYY'), 101, 1110);
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament,stocuri_idstoc) VALUES (TO_DATE('17/06/2020','DD/MM/YYYY'), 102, 1111);
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament,stocuri_idstoc) VALUES (TO_DATE('18/06/2020','DD/MM/YYYY'), 103, 1112);
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament,stocuri_idstoc) VALUES (TO_DATE('19/06/2020','DD/MM/YYYY'), 104, 1113);
INSERT INTO tratament_stoc(datapreluaretratament,tratamente_idtratament,stocuri_idstoc) VALUES (TO_DATE('20/06/2020','DD/MM/YYYY'), 105, 1114);

INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (400,40, 15, 0,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (401,30, 30, 30,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (402,100, 52, 0,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (403,35, 11 , 19,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (404,63, 20, 0,TO_DATE('19/05/2021','DD/MM/YYYY'));
INSERT INTO situatiestocuri(idsituatie,cantitateintrare,cantitateconsumata,necesaraprovizionare, dataprimirestoc) VALUES (405,40, 20, 10,TO_DATE('19/05/2021','DD/MM/YYYY'));

INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (1110,'consumabil', 400);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (1111,'consumabil', 401);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (1112,'consumabil', 402);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (1113,'consumabil', 403);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (1114,'consumabil', 404);
INSERT INTO stocuri(idstoc,tipstoc,situatiestocuri_idsituatie) VALUES (1115,'consumabil', 405);

--============================================--

CREATE TABLESPACE oracle_user_idx_tbs
    DATAFILE '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_test.dbf'
    SIZE 300K
    AUTOEXTEND OFF
    EXTENT MANAGEMENT LOCAL
    UNIFORM SIZE 50K;

CREATE TABLESPACE oracle_user_backup_tbs 
    DATAFILE '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_backup_tbs.dbf'
    SIZE 400K
    AUTOEXTEND OFF
    EXTENT MANAGEMENT LOCAL
    UNIFORM SIZE 100K;
    

DROP TABLESPACE  oracle_user_idx_tbs;
ALTER INDEX tratament_stoc_pk REBUILD tablespace oracle_user_idx_tbs;

--============================================--


ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/ORCL/datafile/oracle_user_test.dbf' AUTOEXTEND ON NEXT 300K maxsize 30M;

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
TABLESPACE test1_backup_tbs AS SELECT * FROM stocuri;
CREATE TABLE tratamente_backup
TABLESPACE test1_backup_tbs AS SELECT * FROM tratamente;
CREATE TABLE ANGAJATI_BACKUP
TABLESPACE test1_backup_tbs AS SELECT * FROM angajati;

INSERT INTO ANGAJATI_BACKUP SELECT t.* FROM ANGAJATI_BACKUP t CROSS JOIN angajati_backup;

--============================================--

set arraysize 300
set autotrace traceonly
select idstoc,tipstoc,situatiestocuri_idsituatie from stocuri;



