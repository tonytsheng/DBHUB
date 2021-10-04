-- ------------ Write DROP-TRIGGER-stage scripts -----------

DROP TRIGGER IF EXISTS ipurchaseorderdetail
ON adventureworks_purchasing.purchaseorderdetail;



DROP TRIGGER IF EXISTS "upurchaseorderdetail_after_UPDATE"
ON adventureworks_purchasing.purchaseorderdetail;



DROP TRIGGER IF EXISTS "upurchaseorderheader_after_UPDATE"
ON adventureworks_purchasing.purchaseorderheader;



-- ------------ Write DROP-FUNCTION-stage scripts -----------

DROP ROUTINE IF EXISTS adventureworks_purchasing.fn_ipurchaseorderdetail();



DROP ROUTINE IF EXISTS adventureworks_purchasing.fn_upurchaseorderdetail();



DROP ROUTINE IF EXISTS adventureworks_purchasing.fn_upurchaseorderheader();



-- ------------ Write DROP-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT fk_productvendor_product_productid_1435152158;



ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT fk_productvendor_unitmeasure_unitmeasurecode_1451152215;



ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT fk_productvendor_vendor_businessentityid_1467152272;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail DROP CONSTRAINT fk_purchaseorderdetail_product_productid_1483152329;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail DROP CONSTRAINT fk_purchaseorderdetail_purchaseorderheader_purchaseorderid_1499152386;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT fk_purchaseorderheader_employee_employeeid_1515152443;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT fk_purchaseorderheader_shipmethod_shipmethodid_1547152557;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT fk_purchaseorderheader_vendor_vendorid_1531152500;



ALTER TABLE adventureworks_purchasing.vendor DROP CONSTRAINT fk_vendor_businessentity_businessentityid_1995154153;



-- ------------ Write DROP-CONSTRAINT-stage scripts -----------

ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT ck_productvendor_averageleadtime_1090102924;



ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT ck_productvendor_lastreceiptcost_1122103038;



ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT ck_productvendor_maxorderqty_1154103152;



ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT ck_productvendor_minorderqty_1138103095;



ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT ck_productvendor_onorderqty_1170103209;



ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT ck_productvendor_standardprice_1106102981;



ALTER TABLE adventureworks_purchasing.productvendor DROP CONSTRAINT pk_productvendor_productid_businessentityid_2078630448;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail DROP CONSTRAINT ck_purchaseorderdetail_orderqty_1218103380;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail DROP CONSTRAINT ck_purchaseorderdetail_receivedqty_1250103494;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail DROP CONSTRAINT ck_purchaseorderdetail_rejectedqty_1266103551;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail DROP CONSTRAINT ck_purchaseorderdetail_unitprice_1234103437;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail DROP CONSTRAINT pk_purchaseorderdetail_purchaseorderid_purchaseorderdetailid_2094630505;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT ck_purchaseorderheader_freight_1474104292;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT ck_purchaseorderheader_shipdate_1426104121;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT ck_purchaseorderheader_status_1410104064;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT ck_purchaseorderheader_subtotal_1442104178;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT ck_purchaseorderheader_taxamt_1458104235;



ALTER TABLE adventureworks_purchasing.purchaseorderheader DROP CONSTRAINT pk_purchaseorderheader_purchaseorderid_2110630562;



ALTER TABLE adventureworks_purchasing.shipmethod DROP CONSTRAINT ck_shipmethod_shipbase_494624805;



ALTER TABLE adventureworks_purchasing.shipmethod DROP CONSTRAINT ck_shipmethod_shiprate_510624862;



ALTER TABLE adventureworks_purchasing.shipmethod DROP CONSTRAINT pk_shipmethod_shipmethodid_155147598;



ALTER TABLE adventureworks_purchasing.vendor DROP CONSTRAINT ck_vendor_creditrating_1166627199;



ALTER TABLE adventureworks_purchasing.vendor DROP CONSTRAINT pk_vendor_businessentityid_299148111;



-- ------------ Write DROP-INDEX-stage scripts -----------

DROP INDEX IF EXISTS adventureworks_purchasing.ix_productvendor_ix_productvendor_businessentityid;



DROP INDEX IF EXISTS adventureworks_purchasing.ix_productvendor_ix_productvendor_unitmeasurecode;



DROP INDEX IF EXISTS adventureworks_purchasing.ix_purchaseorderdetail_ix_purchaseorderdetail_productid;



DROP INDEX IF EXISTS adventureworks_purchasing.ix_purchaseorderheader_ix_purchaseorderheader_employeeid;



DROP INDEX IF EXISTS adventureworks_purchasing.ix_purchaseorderheader_ix_purchaseorderheader_vendorid;



DROP INDEX IF EXISTS adventureworks_purchasing.ix_shipmethod_ak_shipmethod_name;



DROP INDEX IF EXISTS adventureworks_purchasing.ix_shipmethod_ak_shipmethod_rowguid;



DROP INDEX IF EXISTS adventureworks_purchasing.ix_vendor_ak_vendor_accountnumber;



-- ------------ Write DROP-VIEW-stage scripts -----------

DROP VIEW IF EXISTS adventureworks_purchasing.vvendorwithaddresses;



DROP VIEW IF EXISTS adventureworks_purchasing.vvendorwithcontacts;



-- ------------ Write DROP-TABLE-stage scripts -----------

DROP TABLE IF EXISTS adventureworks_purchasing.productvendor;



DROP TABLE IF EXISTS adventureworks_purchasing.purchaseorderdetail;



DROP TABLE IF EXISTS adventureworks_purchasing.purchaseorderheader;



DROP TABLE IF EXISTS adventureworks_purchasing.shipmethod;



DROP TABLE IF EXISTS adventureworks_purchasing.vendor;



-- ------------ Write DROP-DATABASE-stage scripts -----------

-- ------------ Write CREATE-DATABASE-stage scripts -----------

CREATE SCHEMA IF NOT EXISTS adventureworks_purchasing;



-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE adventureworks_purchasing.productvendor(
    productid INTEGER NOT NULL,
    businessentityid INTEGER NOT NULL,
    averageleadtime INTEGER NOT NULL,
    standardprice NUMERIC(19,4) NOT NULL,
    lastreceiptcost NUMERIC(19,4),
    lastreceiptdate TIMESTAMP WITHOUT TIME ZONE,
    minorderqty INTEGER NOT NULL,
    maxorderqty INTEGER NOT NULL,
    onorderqty INTEGER,
    unitmeasurecode CHAR(3) NOT NULL,
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT clock_timestamp()
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE adventureworks_purchasing.purchaseorderdetail(
    purchaseorderid INTEGER NOT NULL,
    purchaseorderdetailid INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    duedate TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    orderqty SMALLINT NOT NULL,
    productid INTEGER NOT NULL,
    unitprice NUMERIC(19,4) NOT NULL,
    linetotal NUMERIC(19,4) NOT NULL GENERATED ALWAYS AS (COALESCE(orderqty * unitprice, 0.00)) STORED,
    receivedqty NUMERIC(8,2) NOT NULL,
    rejectedqty NUMERIC(8,2) NOT NULL,
    stockedqty NUMERIC(9,2) NOT NULL GENERATED ALWAYS AS (COALESCE(receivedqty - rejectedqty, 0.00)) STORED,
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT clock_timestamp()
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE adventureworks_purchasing.purchaseorderheader(
    purchaseorderid INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    revisionnumber SMALLINT NOT NULL DEFAULT (0),
    status SMALLINT NOT NULL DEFAULT (1),
    employeeid INTEGER NOT NULL,
    vendorid INTEGER NOT NULL,
    shipmethodid INTEGER NOT NULL,
    orderdate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    shipdate TIMESTAMP WITHOUT TIME ZONE,
    subtotal NUMERIC(19,4) NOT NULL DEFAULT (0.00),
    taxamt NUMERIC(19,4) NOT NULL DEFAULT (0.00),
    freight NUMERIC(19,4) NOT NULL DEFAULT (0.00),
    totaldue NUMERIC(19,4) NOT NULL GENERATED ALWAYS AS (COALESCE((subtotal + taxamt) + freight, 0)) STORED,
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT clock_timestamp()
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE adventureworks_purchasing.shipmethod(
    shipmethodid INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    name adventureworks_dbo.name NOT NULL,
    shipbase NUMERIC(19,4) NOT NULL DEFAULT (0.00),
    shiprate NUMERIC(19,4) NOT NULL DEFAULT (0.00),
    rowguid UUID NOT NULL DEFAULT aws_sqlserver_ext.newid(),
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT clock_timestamp()
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE adventureworks_purchasing.vendor(
    businessentityid INTEGER NOT NULL,
    accountnumber adventureworks_dbo.accountnumber NOT NULL,
    name adventureworks_dbo.name NOT NULL,
    creditrating SMALLINT NOT NULL,
    preferredvendorstatus adventureworks_dbo.flag NOT NULL DEFAULT (1),
    activeflag adventureworks_dbo.flag NOT NULL DEFAULT (1),
    purchasingwebserviceurl VARCHAR(1024),
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT clock_timestamp()
)
        WITH (
        OIDS=FALSE
        );



-- ------------ Write CREATE-VIEW-stage scripts -----------

CREATE OR REPLACE VIEW adventureworks_purchasing.vvendorwithaddresses (businessentityid, name, addresstype, addressline1, addressline2, city, stateprovincename, postalcode, countryregionname) AS
SELECT
    v.businessentityid, v.name, at.name AS addresstype, a.addressline1, a.addressline2, a.city, sp.name AS stateprovincename, a.postalcode, cr.name AS countryregionname
    FROM adventureworks_purchasing.vendor AS v
    INNER JOIN adventureworks_person.businessentityaddress AS bea
        ON bea.businessentityid = v.businessentityid
    INNER JOIN adventureworks_person.address AS a
        ON a.addressid = bea.addressid
    INNER JOIN adventureworks_person.stateprovince AS sp
        ON sp.stateprovinceid = a.stateprovinceid
    INNER JOIN adventureworks_person.countryregion AS cr
        ON LOWER(cr.countryregioncode) = LOWER(sp.countryregioncode)
    INNER JOIN adventureworks_person.addresstype AS at
        ON at.addresstypeid = bea.addresstypeid;



CREATE OR REPLACE VIEW adventureworks_purchasing.vvendorwithcontacts (businessentityid, name, contacttype, title, firstname, middlename, lastname, suffix, phonenumber, phonenumbertype, emailaddress, emailpromotion) AS
SELECT
    v.businessentityid, v.name, ct.name AS contacttype, p.title, p.firstname, p.middlename, p.lastname, p.suffix, pp.phonenumber, pnt.name AS phonenumbertype, ea.emailaddress, p.emailpromotion
    FROM adventureworks_purchasing.vendor AS v
    INNER JOIN adventureworks_person.businessentitycontact AS bec
        ON bec.businessentityid = v.businessentityid
    INNER JOIN adventureworks_person.contacttype AS ct
        ON ct.contacttypeid = bec.contacttypeid
    INNER JOIN adventureworks_person.person AS p
        ON p.businessentityid = bec.personid
    LEFT OUTER JOIN adventureworks_person.emailaddress AS ea
        ON ea.businessentityid = p.businessentityid
    LEFT OUTER JOIN adventureworks_person.personphone AS pp
        ON pp.businessentityid = p.businessentityid
    LEFT OUTER JOIN adventureworks_person.phonenumbertype AS pnt
        ON pnt.phonenumbertypeid = pp.phonenumbertypeid;



-- ------------ Write CREATE-INDEX-stage scripts -----------

CREATE INDEX ix_productvendor_ix_productvendor_businessentityid
ON adventureworks_purchasing.productvendor
USING BTREE (businessentityid ASC);



CREATE INDEX ix_productvendor_ix_productvendor_unitmeasurecode
ON adventureworks_purchasing.productvendor
USING BTREE (unitmeasurecode ASC);



CREATE INDEX ix_purchaseorderdetail_ix_purchaseorderdetail_productid
ON adventureworks_purchasing.purchaseorderdetail
USING BTREE (productid ASC);



CREATE INDEX ix_purchaseorderheader_ix_purchaseorderheader_employeeid
ON adventureworks_purchasing.purchaseorderheader
USING BTREE (employeeid ASC);



CREATE INDEX ix_purchaseorderheader_ix_purchaseorderheader_vendorid
ON adventureworks_purchasing.purchaseorderheader
USING BTREE (vendorid ASC);



CREATE UNIQUE INDEX ix_shipmethod_ak_shipmethod_name
ON adventureworks_purchasing.shipmethod
USING BTREE (name ASC);



CREATE UNIQUE INDEX ix_shipmethod_ak_shipmethod_rowguid
ON adventureworks_purchasing.shipmethod
USING BTREE (rowguid ASC);



CREATE UNIQUE INDEX ix_vendor_ak_vendor_accountnumber
ON adventureworks_purchasing.vendor
USING BTREE (accountnumber ASC);



-- ------------ Write CREATE-CONSTRAINT-stage scripts -----------

ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT ck_productvendor_averageleadtime_1090102924 CHECK (
(averageleadtime >= (1)));



ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT ck_productvendor_lastreceiptcost_1122103038 CHECK (
(lastreceiptcost > (0.00)));



ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT ck_productvendor_maxorderqty_1154103152 CHECK (
(maxorderqty >= (1)));



ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT ck_productvendor_minorderqty_1138103095 CHECK (
(minorderqty >= (1)));



ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT ck_productvendor_onorderqty_1170103209 CHECK (
(onorderqty >= (0)));



ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT ck_productvendor_standardprice_1106102981 CHECK (
(standardprice > (0.00)));



ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT pk_productvendor_productid_businessentityid_2078630448 PRIMARY KEY (productid, businessentityid);



ALTER TABLE adventureworks_purchasing.purchaseorderdetail
ADD CONSTRAINT ck_purchaseorderdetail_orderqty_1218103380 CHECK (
(orderqty > (0)));



ALTER TABLE adventureworks_purchasing.purchaseorderdetail
ADD CONSTRAINT ck_purchaseorderdetail_receivedqty_1250103494 CHECK (
(receivedqty >= (0.00)));



ALTER TABLE adventureworks_purchasing.purchaseorderdetail
ADD CONSTRAINT ck_purchaseorderdetail_rejectedqty_1266103551 CHECK (
(rejectedqty >= (0.00)));



ALTER TABLE adventureworks_purchasing.purchaseorderdetail
ADD CONSTRAINT ck_purchaseorderdetail_unitprice_1234103437 CHECK (
(unitprice >= (0.00)));



ALTER TABLE adventureworks_purchasing.purchaseorderdetail
ADD CONSTRAINT pk_purchaseorderdetail_purchaseorderid_purchaseorderdetailid_2094630505 PRIMARY KEY (purchaseorderid, purchaseorderdetailid);



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT ck_purchaseorderheader_freight_1474104292 CHECK (
(freight >= (0.00)));



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT ck_purchaseorderheader_shipdate_1426104121 CHECK (
(shipdate >= orderdate OR shipdate IS NULL));



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT ck_purchaseorderheader_status_1410104064 CHECK (
(status >= (1) AND status <= (4)));



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT ck_purchaseorderheader_subtotal_1442104178 CHECK (
(subtotal >= (0.00)));



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT ck_purchaseorderheader_taxamt_1458104235 CHECK (
(taxamt >= (0.00)));



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT pk_purchaseorderheader_purchaseorderid_2110630562 PRIMARY KEY (purchaseorderid);



ALTER TABLE adventureworks_purchasing.shipmethod
ADD CONSTRAINT ck_shipmethod_shipbase_494624805 CHECK (
(shipbase > (0.00)));



ALTER TABLE adventureworks_purchasing.shipmethod
ADD CONSTRAINT ck_shipmethod_shiprate_510624862 CHECK (
(shiprate > (0.00)));



ALTER TABLE adventureworks_purchasing.shipmethod
ADD CONSTRAINT pk_shipmethod_shipmethodid_155147598 PRIMARY KEY (shipmethodid);



ALTER TABLE adventureworks_purchasing.vendor
ADD CONSTRAINT ck_vendor_creditrating_1166627199 CHECK (
(creditrating >= (1) AND creditrating <= (5)));



ALTER TABLE adventureworks_purchasing.vendor
ADD CONSTRAINT pk_vendor_businessentityid_299148111 PRIMARY KEY (businessentityid);



-- ------------ Write CREATE-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT fk_productvendor_product_productid_1435152158 FOREIGN KEY (productid) 
REFERENCES adventureworks_production.product (productid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT fk_productvendor_unitmeasure_unitmeasurecode_1451152215 FOREIGN KEY (unitmeasurecode) 
REFERENCES adventureworks_production.unitmeasure (unitmeasurecode)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



ALTER TABLE adventureworks_purchasing.productvendor
ADD CONSTRAINT fk_productvendor_vendor_businessentityid_1467152272 FOREIGN KEY (businessentityid) 
REFERENCES adventureworks_purchasing.vendor (businessentityid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail
ADD CONSTRAINT fk_purchaseorderdetail_product_productid_1483152329 FOREIGN KEY (productid) 
REFERENCES adventureworks_production.product (productid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



ALTER TABLE adventureworks_purchasing.purchaseorderdetail
ADD CONSTRAINT fk_purchaseorderdetail_purchaseorderheader_purchaseorderid_1499152386 FOREIGN KEY (purchaseorderid) 
REFERENCES adventureworks_purchasing.purchaseorderheader (purchaseorderid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT fk_purchaseorderheader_employee_employeeid_1515152443 FOREIGN KEY (employeeid) 
REFERENCES adventureworks_humanresources.employee (businessentityid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT fk_purchaseorderheader_shipmethod_shipmethodid_1547152557 FOREIGN KEY (shipmethodid) 
REFERENCES adventureworks_purchasing.shipmethod (shipmethodid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



ALTER TABLE adventureworks_purchasing.purchaseorderheader
ADD CONSTRAINT fk_purchaseorderheader_vendor_vendorid_1531152500 FOREIGN KEY (vendorid) 
REFERENCES adventureworks_purchasing.vendor (businessentityid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



ALTER TABLE adventureworks_purchasing.vendor
ADD CONSTRAINT fk_vendor_businessentity_businessentityid_1995154153 FOREIGN KEY (businessentityid) 
REFERENCES adventureworks_person.businessentity (businessentityid)
ON UPDATE NO ACTION
ON DELETE NO ACTION;



-- ------------ Write CREATE-FUNCTION-stage scripts -----------

CREATE OR REPLACE FUNCTION adventureworks_purchasing.fn_ipurchaseorderdetail()
RETURNS trigger
AS
$BODY$
DECLARE
    var_Count INTEGER;
    usplogerror$par_ErrorLogID INTEGER;
    usplogerror$ReturnCode INTEGER;
BEGIN
    /*
    [7833 - Severity CRITICAL - Migration @@rowcount function in current context is not supported. Perform a manual conversion.]
    SET @Count = @@ROWCOUNT;
    */
    IF var_Count = 0 THEN
        RETURN NULL;
    END IF;
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    BEGIN
        INSERT INTO adventureworks_production.transactionhistory (productid, referenceorderid, referenceorderlineid, transactiontype, transactiondate, quantity, actualcost)
        SELECT
            inserted.ProductID, inserted.PurchaseOrderID, inserted.PurchaseOrderDetailID, 'P', clock_timestamp(), inserted.OrderQty, inserted.UnitPrice
            FROM inserted
            INNER JOIN adventureworks_purchasing.purchaseorderheader
                ON inserted.PurchaseOrderID = adventureworks_purchasing.purchaseorderheader.purchaseorderid;
        /* Update SubTotal in PurchaseOrderHeader record. Note that this causes the */
        /* PurchaseOrderHeader trigger to fire which will update the RevisionNumber. */
        UPDATE adventureworks_purchasing.purchaseorderheader
        SET subtotal = (SELECT
            SUM(adventureworks_purchasing.purchaseorderdetail.linetotal)
            FROM adventureworks_purchasing.purchaseorderdetail
            WHERE adventureworks_purchasing.purchaseorderheader.purchaseorderid = adventureworks_purchasing.purchaseorderdetail.purchaseorderid)
            WHERE adventureworks_purchasing.purchaseorderheader.purchaseorderid IN (SELECT
                inserted.PurchaseOrderID
                FROM inserted);
        RETURN NULL;
        EXCEPTION
            WHEN OTHERS THEN
                CALL adventureworks_dbo.uspprinterror();
                /* Rollback any active or uncommittable transactions before */
                /* inserting information in the ErrorLog */
                
                /*
                [7811 - Severity CRITICAL - PostgreSQL doesn't support the @@TRANCOUNT function. Create a user-defined function.]
                IF @@TRANCOUNT > 0
                        BEGIN
                            ROLLBACK TRANSACTION;
                        END
                */
                CALL adventureworks_dbo.usplogerror(par_ErrorLogID => usplogerror$par_ErrorLogID, return_code => usplogerror$ReturnCode);
    END;
    RETURN NULL;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_purchasing.fn_upurchaseorderdetail()
RETURNS trigger
AS
$BODY$
DECLARE
    update$ProductID BOOLEAN;
    update$OrderQty BOOLEAN;
    update$UnitPrice BOOLEAN;
DECLARE
    var_Count INTEGER;
    usplogerror$par_ErrorLogID INTEGER;
    usplogerror$ReturnCode INTEGER;
BEGIN
    /*
    [7833 - Severity CRITICAL - Migration @@rowcount function in current context is not supported. Perform a manual conversion.]
    SET @Count = @@ROWCOUNT;
    */
    IF var_Count = 0 THEN
        RETURN NULL;
    END IF;
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    BEGIN
        CASE TG_OP
            WHEN 'INSERT' THEN
                update$ProductID = TRUE;
            WHEN 'UPDATE' THEN
                update$ProductID = ((SELECT
                    array_agg(ProductID)
                    FROM deleted) != (SELECT
                    array_agg(ProductID)
                    FROM inserted));
            ELSE
                update$ProductID := FALSE;
        END CASE;
        CASE TG_OP
            WHEN 'INSERT' THEN
                update$OrderQty = TRUE;
            WHEN 'UPDATE' THEN
                update$OrderQty = ((SELECT
                    array_agg(OrderQty)
                    FROM deleted) != (SELECT
                    array_agg(OrderQty)
                    FROM inserted));
            ELSE
                update$OrderQty := FALSE;
        END CASE;
        CASE TG_OP
            WHEN 'INSERT' THEN
                update$UnitPrice = TRUE;
            WHEN 'UPDATE' THEN
                update$UnitPrice = ((SELECT
                    array_agg(UnitPrice)
                    FROM deleted) != (SELECT
                    array_agg(UnitPrice)
                    FROM inserted));
            ELSE
                update$UnitPrice := FALSE;
        END CASE;

        IF update$ProductID OR update$OrderQty OR update$UnitPrice THEN
            /* Insert record into TransactionHistory */
            INSERT INTO adventureworks_production.transactionhistory (productid, referenceorderid, referenceorderlineid, transactiontype, transactiondate, quantity, actualcost)
            SELECT
                inserted.ProductID, inserted.PurchaseOrderID, inserted.PurchaseOrderDetailID, 'P', clock_timestamp(), inserted.OrderQty, inserted.UnitPrice
                FROM inserted
                INNER JOIN adventureworks_purchasing.purchaseorderdetail
                    ON inserted.PurchaseOrderID = adventureworks_purchasing.purchaseorderdetail.purchaseorderid;
            /* Update SubTotal in PurchaseOrderHeader record. Note that this causes the */
            /* PurchaseOrderHeader trigger to fire which will update the RevisionNumber. */
            UPDATE adventureworks_purchasing.purchaseorderheader
            SET subtotal = (SELECT
                SUM(adventureworks_purchasing.purchaseorderdetail.linetotal)
                FROM adventureworks_purchasing.purchaseorderdetail
                WHERE adventureworks_purchasing.purchaseorderheader.purchaseorderid = adventureworks_purchasing.purchaseorderdetail.purchaseorderid)
                WHERE adventureworks_purchasing.purchaseorderheader.purchaseorderid IN (SELECT
                    inserted.PurchaseOrderID
                    FROM inserted);
            UPDATE adventureworks_purchasing.purchaseorderdetail
            SET modifieddate = clock_timestamp()
            FROM inserted
                WHERE inserted.PurchaseOrderID = adventureworks_purchasing.purchaseorderdetail.purchaseorderid AND inserted.PurchaseOrderDetailID = adventureworks_purchasing.purchaseorderdetail.purchaseorderdetailid;
        END IF;
        RETURN NULL;
        EXCEPTION
            WHEN OTHERS THEN
                CALL adventureworks_dbo.uspprinterror();
                /* Rollback any active or uncommittable transactions before */
                /* inserting information in the ErrorLog */
                
                /*
                [7811 - Severity CRITICAL - PostgreSQL doesn't support the @@TRANCOUNT function. Create a user-defined function.]
                IF @@TRANCOUNT > 0
                        BEGIN
                            ROLLBACK TRANSACTION;
                        END
                */
                CALL adventureworks_dbo.usplogerror(par_ErrorLogID => usplogerror$par_ErrorLogID, return_code => usplogerror$ReturnCode);
    END;
    RETURN NULL;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_purchasing.fn_upurchaseorderheader()
RETURNS trigger
AS
$BODY$
DECLARE
    update$Status BOOLEAN;
DECLARE
    var_Count INTEGER;
    usplogerror$par_ErrorLogID INTEGER;
    usplogerror$ReturnCode INTEGER;
BEGIN
    /*
    [7833 - Severity CRITICAL - Migration @@rowcount function in current context is not supported. Perform a manual conversion.]
    SET @Count = @@ROWCOUNT;
    */
    IF var_Count = 0 THEN
        RETURN NULL;
    END IF;
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    BEGIN
        /* Update RevisionNumber for modification of any field EXCEPT the Status. */
        CASE TG_OP
            WHEN 'INSERT' THEN
                update$Status = TRUE;
            WHEN 'UPDATE' THEN
                update$Status = ((SELECT
                    array_agg(Status)
                    FROM deleted) != (SELECT
                    array_agg(Status)
                    FROM inserted));
            ELSE
                update$Status := FALSE;
        END CASE;

        IF NOT update$Status THEN
            UPDATE adventureworks_purchasing.purchaseorderheader
            SET revisionnumber = adventureworks_purchasing.purchaseorderheader.revisionnumber + 1
                WHERE adventureworks_purchasing.purchaseorderheader.purchaseorderid IN (SELECT
                    inserted.PurchaseOrderID
                    FROM inserted);
        END IF;
        RETURN NULL;
        EXCEPTION
            WHEN OTHERS THEN
                CALL adventureworks_dbo.uspprinterror();
                /* Rollback any active or uncommittable transactions before */
                /* inserting information in the ErrorLog */
                
                /*
                [7811 - Severity CRITICAL - PostgreSQL doesn't support the @@TRANCOUNT function. Create a user-defined function.]
                IF @@TRANCOUNT > 0
                        BEGIN
                            ROLLBACK TRANSACTION;
                        END
                */
                CALL adventureworks_dbo.usplogerror(par_ErrorLogID => usplogerror$par_ErrorLogID, return_code => usplogerror$ReturnCode);
    END;
    RETURN NULL;
END;
$BODY$
LANGUAGE  plpgsql;



-- ------------ Write CREATE-TRIGGER-stage scripts -----------

CREATE TRIGGER ipurchaseorderdetail
AFTER INSERT
ON adventureworks_purchasing.purchaseorderdetail
FOR EACH STATEMENT EXECUTE PROCEDURE adventureworks_purchasing.fn_ipurchaseorderdetail();



CREATE TRIGGER "upurchaseorderdetail_after_UPDATE"
AFTER UPDATE
ON adventureworks_purchasing.purchaseorderdetail
REFERENCING OLD TABLE AS deleted NEW TABLE AS inserted
FOR EACH STATEMENT EXECUTE PROCEDURE adventureworks_purchasing.fn_upurchaseorderdetail();



CREATE TRIGGER "upurchaseorderheader_after_UPDATE"
AFTER UPDATE
ON adventureworks_purchasing.purchaseorderheader
REFERENCING OLD TABLE AS deleted NEW TABLE AS inserted
FOR EACH STATEMENT EXECUTE PROCEDURE adventureworks_purchasing.fn_upurchaseorderheader();



