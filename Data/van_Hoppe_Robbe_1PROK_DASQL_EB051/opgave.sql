-- Vraag 4
CREATE TABLE ChemischeStoffen
(
    ChemID                  INT				IDENTITY(1,1)	
											CONSTRAINT	chemid_pk		PRIMARY KEY,
    Beschrijving            VARCHAR(40)	    CONSTRAINT	beschr_check	CHECK	    (Beschrijving <> '' AND 
																				    LOWER(Beschrijving) = Beschrijving),
	Klasse					CHAR(5)		    CONSTRAINT	klasse_format	CHECK	    (CHARINDEX(Klasse,'C') = 0),
	Gevaar					INT				CONSTRAINT	gevaar_len		CHECK	    (gevaar < 10),
	VervalDatum				DATETIME		DEFAULT		DATEADD(YEAR, 2, SYSDATETIME())
);

CREATE TABLE Producten 
(
	ProductID				INT				IDENTITY(1,1)
											CONSTRAINT	productid_pk		PRIMARY KEY,
	Beschrijving			VARCHAR(50)		CONSTRAINT	beschr_nn			NOT NULL,
);

CREATE TABLE ChemischeProducten
(
	ProductID				INT				CONSTRAINT	productid_fk		REFERENCES	Producten
											CONSTRAINT	productid_nn		NOT NULL,
	ChemID					INT				CONSTRAINT	chemid_fk			REFERENCES	ChemischeStoffen
											CONSTRAINT	chemid_nn			NOT NULL,
	Hoeveelheid				DECIMAL(4,2),
	PRIMARY KEY(ProductID,ChemID)
);

-- Vraag 5
INSERT INTO	dbo.ChemischeStoffen (Beschrijving, Klasse, Gevaar, VervalDatum) 
VALUES		('Waterstof', 'C3260', 6, CAST('2024-9-23' AS DATE));

INSERT INTO	dbo.ChemischeStoffen (Beschrijving, Klasse, Gevaar, VervalDatum) 
VALUES		('Zuurstof', 'C4688', 2, CAST('2020-12-24' AS DATE));

INSERT INTO	dbo.Producten (Beschrijving)
VALUES		('Metalen omhulsel');

INSERT INTO	dbo.Producten (Beschrijving)
VALUES		('Duikersfles');

INSERT INTO	dbo.ChemischeProducten (ProductID, ChemID, Hoeveelheid)
VALUES		(1, 1, 5.5);

INSERT INTO	dbo.ChemischeProducten (ProductID, ChemID, Hoeveelheid)
VALUES		(1, 2, 1.8);

-- vraag 6
CREATE PROCEDURE sp_ChangeDescriptions
@chemid		INT, @newchemdesc	VARCHAR(40), @productid	INT, @newproductdesc	VARCHAR(50) 
AS
BEGIN
	BEGIN TRANSACTION
	UPDATE	ChemischeStoffen	SET Beschrijving = @newchemdesc		WHERE ChemID = @chemid;
	UPDATE	Producten			SET Beschrijving = @newproductdesc	WHERE ProductID = @productid;
	COMMIT TRANSACTION
END;

EXEC sp_ChangeDescriptions 1, 'Koolstof', 2, 'Gaston';