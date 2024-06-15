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
