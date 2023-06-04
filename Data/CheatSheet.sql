/* 
Normalisatie:
1NV: Verwijder de zich herhalendedeelverzamelingen
2NV: Verwijder de gedeeltelijke afhankelijkheden
3NV: Verwijder de attributen die ook functioneel afhankelijk zijn vanander (niet-sleutel) attributen – transitieve afhankelijkheden

1NV:
Elementare gegevens inventarisatie
Procesgegevens verwijderen
Doe het volgende tot er geen nieuwe groepen zijn:
    - Zoek een groep met een gemeenschappelijke sleutel
    - Geef de deelverzameling aan die een herhaald aantal keren voorkomt

2NV:
Verwijder de attributen diefunctioneel afhankelijk zijn vanslechts een gedeelte van de sleutel
Alleen groepen met een samengestelde sleutel komen in aanmerking!

3NV:
Verwijder attributen die ookfunctioneel afhankelijk zijn van ander(niet-sleutel) attributen
Bij de stap naar de derde normaalvorm moeten de attributen
• die functioneel afhankelijk zijn van de volledige sleutel (2NV)
• maar ook nog functioneel afhankelijk zijn van andere attributen
in aparte groepen worden opgenomen
*/

/*
DDL
*/

-- Data Definition Language
CREATE TABLE medewerkers (
    medewerker_id INT NOT NULL AUTO_INCREMENT,
    voornaam VARCHAR(255) NOT NULL CONSTRAINT voornaam_nn,
                                    CONSTRAINT voornaam_ck CHECK (voornaam <> ''),
                                    CONSTRAINT voornaam_upparcase_ck CHECK (voornaam = UPPER(voornaam)),
                                    CONSTRAINT voornaam_lengte_ck CHECK (LENGTH(voornaam) > 2),
    achternaam VARCHAR(255) NOT NULL,
    functie VARCHAR(255) NOT NULL,
    PRIMARY KEY (medewerker_id)
);

CREATE TABLE afdelingen(
    anr         NUMBER(2)       constraint A_PK         primary key
                                constraint A_ANR_CHK    check ( mod(anr,10) = 0 ),
    naam        VARCHAR2(20)    constraint A_NAAM_NN    not null
                                constraint A_NAAM_UN    unique
                                constraint A_NAAM_CHK   check (naam = upper(naam)),
    locatie     VARCHAR2(20)    constraint A_LOC_NN     not null
                                constraint A_LOC_CHK    check (locatie = upper(locatie)),
    hoofd       NUMBER(4)       constraint A_HOOFD_FK   references medewerker
);

CREATE TABLE klanten (
    klant_id INT NOT NULL AUTO_INCREMENT,
    voornaam VARCHAR(255) NOT NULL,
    achternaam VARCHAR(255) NOT NULL,
    PRIMARY KEY (klant_id)
);

ALTER TABLE klanten ADD COLUMN email VARCHAR(255) NOT NULL;
ALTER TABLE klanten DROP COLUMN email;
ALTER TABLE klanten MODIFY COLUMN email VARCHAR(255) NOT NULL;
ALTER TABLE klanten RENAME TO klant;
ALTER TABLE klant ADD COLUMN email VARCHAR(255) NOT NULL AFTER achternaam;

DROP TABLE klant;

-- Data Manipulation Language

INSERT INTO medewerkers (voornaam, achternaam, functie) VALUES ('Jan', 'Janssen', 'Manager');

CREATE TABLE afdelingen(
    anr         NUMBER(2)       constraint A_PK         primary key
                                constraint A_ANR_CHK    check ( mod(anr,10) = 0 ),
    naam        VARCHAR2(20)    constraint A_NAAM_NN    not null
                                constraint A_NAAM_UN    unique
                                constraint A_NAAM_CHK   check (naam = upper(naam)),
    locatie     VARCHAR2(20)    constraint A_LOC_NN     not null
                                constraint A_LOC_CHK    check (locatie = upper(locatie)),
    hoofd       NUMBER(4)       constraint A_HOOFD_FK   references medewerker
);

-- Datatypes:

Data type	        Description	                            Max size	                Storage
char(n)	            Fixed width character string	        8,000 characters	        Defined width
varchar(n)	        Variable width character string	        8,000 characters	        2 bytes + number of chars
varchar(max)	    Variable width character string	        1,073,741,824 characters	2 bytes + number of chars
text	            Variable width character string	        2GB of text data	        4 bytes + number of chars
nchar	            Fixed width Unicode string	            4,000 characters	        Defined width x 2
nvarchar	        Variable width Unicode string	        4,000 characters	 
nvarchar(max)	    Variable width Unicode string	        536,870,912 characters	 
ntext	            Variable width Unicode string	        2GB of text data	 
binary(n)	        Fixed width binary string	            8,000 bytes	 
varbinary	        Variable width binary string	        8,000 bytes	 
varbinary(max)	    Variable width binary string	        2GB	 
image	            Variable width binary string	        2GB	

-- Datadictionary
SELECT colno, cname, coltype, precision, scale, defaultval, nullsFROM colWHERE tname = 'MEDEWERKERS';
SELECT constraint_name, constraint_type, search_condition FROM user_constraints WHERE table_name = 'MEDEWERKERS';

-- Indexes
CREATE INDEX idx_geboortedatum ON medewerkers (gbdatum);
CREATE INDEX idx_volnaam ON medewerkers (naam, voorn);
SELECT index_name, uniqueness, table_name FROM user_indexes;
DROP INDEX indexnaam;

-- sequences
CREATE SEQUENCE sequencenaam;
ALTER SEQUENCE sequencenaam;
DROP SEQUENCE sequencenaam;

CREATE SEQUENCE id_seq2 
INCREMENT BY 103
START WITH 104 
MINVALUE 105 
MAXVALUE 1006 
CYCLE 7 
CACHE 5;
