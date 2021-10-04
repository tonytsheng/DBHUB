-- ------------ Write DROP-FUNCTION-stage scripts -----------

DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetaccountingenddate();



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetaccountingstartdate();



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetcontactinformation(OUT INTEGER, IN INTEGER, OUT VARCHAR, OUT VARCHAR, OUT VARCHAR, OUT VARCHAR);



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetdocumentstatustext(IN SMALLINT);



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetproductdealerprice(IN INTEGER, IN TIMESTAMP WITHOUT TIME ZONE);



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetproductlistprice(IN INTEGER, IN TIMESTAMP WITHOUT TIME ZONE);



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetproductstandardcost(IN INTEGER, IN TIMESTAMP WITHOUT TIME ZONE);



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetpurchaseorderstatustext(IN SMALLINT);



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetsalesorderstatustext(IN SMALLINT);



DROP ROUTINE IF EXISTS adventureworks_dbo.ufngetstock(IN INTEGER);



DROP ROUTINE IF EXISTS adventureworks_dbo.ufnleadingzeros(IN INTEGER);



-- ------------ Write DROP-PROCEDURE-stage scripts -----------

DROP ROUTINE IF EXISTS adventureworks_dbo.uspgetbillofmaterials(IN INTEGER, IN TIMESTAMP WITHOUT TIME ZONE, INOUT refcursor);



DROP ROUTINE IF EXISTS adventureworks_dbo.uspgetemployeemanagers(IN INTEGER, INOUT refcursor);



DROP ROUTINE IF EXISTS adventureworks_dbo.uspgetmanageremployees(IN INTEGER, INOUT refcursor);



DROP ROUTINE IF EXISTS adventureworks_dbo.uspgetwhereusedproductid(IN INTEGER, IN TIMESTAMP WITHOUT TIME ZONE, INOUT refcursor);



DROP ROUTINE IF EXISTS adventureworks_dbo.usplogerror(INOUT INTEGER, INOUT int);



DROP ROUTINE IF EXISTS adventureworks_dbo.uspprinterror();



DROP ROUTINE IF EXISTS adventureworks_dbo.uspsearchcandidateresumes(IN VARCHAR, IN NUMERIC, IN NUMERIC, IN INTEGER, INOUT refcursor, INOUT refcursor, INOUT refcursor, INOUT refcursor);



-- ------------ Write DROP-CONSTRAINT-stage scripts -----------

ALTER TABLE adventureworks_dbo.awbuildversion DROP CONSTRAINT pk_awbuildversion_systeminformationid_1406628054;



ALTER TABLE adventureworks_dbo.databaselog DROP CONSTRAINT pk_databaselog_databaselogid_1614628795;



ALTER TABLE adventureworks_dbo.errorlog DROP CONSTRAINT pk_errorlog_errorlogid_645577338;



-- ------------ Write DROP-TABLE-stage scripts -----------

DROP TABLE IF EXISTS adventureworks_dbo.awbuildversion;



DROP TABLE IF EXISTS adventureworks_dbo.databaselog;



DROP TABLE IF EXISTS adventureworks_dbo.errorlog;



-- ------------ Write DROP-DOMAIN-stage scripts -----------

DROP DOMAIN IF EXISTS adventureworks_dbo.accountnumber;



DROP DOMAIN IF EXISTS adventureworks_dbo.flag;



DROP DOMAIN IF EXISTS adventureworks_dbo.name;



DROP DOMAIN IF EXISTS adventureworks_dbo.namestyle;



DROP DOMAIN IF EXISTS adventureworks_dbo.ordernumber;



DROP DOMAIN IF EXISTS adventureworks_dbo.phone;



-- ------------ Write DROP-DATABASE-stage scripts -----------

-- ------------ Write CREATE-DATABASE-stage scripts -----------

CREATE SCHEMA IF NOT EXISTS adventureworks_dbo;



-- ------------ Write CREATE-DOMAIN-stage scripts -----------

CREATE DOMAIN adventureworks_dbo.accountnumber AS VARCHAR(30) NULL;



CREATE DOMAIN adventureworks_dbo.flag AS NUMERIC(1) NOT NULL;



CREATE DOMAIN adventureworks_dbo.name AS VARCHAR(100) NULL;



CREATE DOMAIN adventureworks_dbo.namestyle AS NUMERIC(1) NOT NULL;



CREATE DOMAIN adventureworks_dbo.ordernumber AS VARCHAR(50) NULL;



CREATE DOMAIN adventureworks_dbo.phone AS VARCHAR(50) NULL;



-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE adventureworks_dbo.awbuildversion(
    systeminformationid SMALLINT NOT NULL GENERATED ALWAYS AS IDENTITY,
    "Database Version" VARCHAR(25) NOT NULL,
    versiondate TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    modifieddate TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT clock_timestamp()
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE adventureworks_dbo.databaselog(
    databaselogid INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    posttime TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    databaseuser VARCHAR(128) NOT NULL,
    event VARCHAR(128) NOT NULL,
    schema VARCHAR(128),
    object VARCHAR(128),
    tsql VARCHAR(1) NOT NULL,
    xmlevent XML NOT NULL
)
        WITH (
        OIDS=FALSE
        );



CREATE TABLE adventureworks_dbo.errorlog(
    errorlogid INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY,
    errortime TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT clock_timestamp(),
    username VARCHAR(128) NOT NULL,
    errornumber INTEGER NOT NULL,
    errorseverity INTEGER,
    errorstate INTEGER,
    errorprocedure VARCHAR(126),
    errorline INTEGER,
    errormessage VARCHAR(4000) NOT NULL
)
        WITH (
        OIDS=FALSE
        );



-- ------------ Write CREATE-CONSTRAINT-stage scripts -----------

ALTER TABLE adventureworks_dbo.awbuildversion
ADD CONSTRAINT pk_awbuildversion_systeminformationid_1406628054 PRIMARY KEY (systeminformationid);



ALTER TABLE adventureworks_dbo.databaselog
ADD CONSTRAINT pk_databaselog_databaselogid_1614628795 PRIMARY KEY (databaselogid);



ALTER TABLE adventureworks_dbo.errorlog
ADD CONSTRAINT pk_errorlog_errorlogid_645577338 PRIMARY KEY (errorlogid);



-- ------------ Write CREATE-FUNCTION-stage scripts -----------

CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetaccountingenddate()
RETURNS TIMESTAMP WITHOUT TIME ZONE
AS
$BODY$
BEGIN
    RETURN aws_sqlserver_ext.conv_string_to_datetime('DATETIME', '20040701', 112) + (- 2::NUMERIC || ' MILLISECOND')::INTERVAL;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetaccountingstartdate()
RETURNS TIMESTAMP WITHOUT TIME ZONE
AS
$BODY$
BEGIN
    RETURN aws_sqlserver_ext.conv_string_to_datetime('DATETIME', '20030701', 112);
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetcontactinformation(IN par_personid INTEGER)
RETURNS TABLE (personid INTEGER, firstname VARCHAR, lastname VARCHAR, jobtitle VARCHAR, businessentitytype VARCHAR)
AS
$BODY$
/* Columns returned by the function */
/* Returns the first name, last name, job title and business entity type for the specified contact. */
/* Since a contact can serve multiple roles, more than one row may be returned. */
# variable_conflict use_column
BEGIN
    DROP TABLE IF EXISTS ufngetcontactinformation$tmptbl;
    CREATE TEMPORARY TABLE ufngetcontactinformation$tmptbl
    (
        /* Columns returned by the function */
        personid INTEGER NOT NULL,
        firstname VARCHAR(50) NULL,
        lastname VARCHAR(50) NULL,
        jobtitle VARCHAR(50) NULL,
        businessentitytype VARCHAR(50) NULL);

    IF par_PersonID IS NOT NULL THEN
        IF EXISTS (SELECT
            *
            FROM adventureworks_humanresources.employee AS e
            WHERE e.businessentityid = par_PersonID) THEN
            INSERT INTO ufngetcontactinformation$tmptbl
            SELECT
                par_PersonID, p.firstname, p.lastname, e.jobtitle, 'Employee'
                FROM adventureworks_humanresources.employee AS e
                INNER JOIN adventureworks_person.person AS p
                    ON p.businessentityid = e.businessentityid
                WHERE e.businessentityid = par_PersonID;
        END IF;

        IF EXISTS (SELECT
            *
            FROM adventureworks_purchasing.vendor AS v
            INNER JOIN adventureworks_person.businessentitycontact AS bec
                ON bec.businessentityid = v.businessentityid
            WHERE bec.personid = par_PersonID) THEN
            INSERT INTO ufngetcontactinformation$tmptbl
            SELECT
                par_PersonID, p.firstname, p.lastname, ct.name, 'Vendor Contact'
                FROM adventureworks_purchasing.vendor AS v
                INNER JOIN adventureworks_person.businessentitycontact AS bec
                    ON bec.businessentityid = v.businessentityid
                INNER JOIN adventureworks_person.contacttype AS ct
                    ON ct.contacttypeid = bec.contacttypeid
                INNER JOIN adventureworks_person.person AS p
                    ON p.businessentityid = bec.personid
                WHERE bec.personid = par_PersonID;
        END IF;

        IF EXISTS (SELECT
            *
            FROM adventureworks_sales.store AS s
            INNER JOIN adventureworks_person.businessentitycontact AS bec
                ON bec.businessentityid = s.businessentityid
            WHERE bec.personid = par_PersonID) THEN
            INSERT INTO ufngetcontactinformation$tmptbl
            SELECT
                par_PersonID, p.firstname, p.lastname, ct.name, 'Store Contact'
                FROM adventureworks_sales.store AS s
                INNER JOIN adventureworks_person.businessentitycontact AS bec
                    ON bec.businessentityid = s.businessentityid
                INNER JOIN adventureworks_person.contacttype AS ct
                    ON ct.contacttypeid = bec.contacttypeid
                INNER JOIN adventureworks_person.person AS p
                    ON p.businessentityid = bec.personid
                WHERE bec.personid = par_PersonID;
        END IF;

        IF EXISTS (SELECT
            *
            FROM adventureworks_person.person AS p
            INNER JOIN adventureworks_sales.customer AS c
                ON c.personid = p.businessentityid
            WHERE p.businessentityid = par_PersonID AND c.storeid IS NULL) THEN
            INSERT INTO ufngetcontactinformation$tmptbl
            SELECT
                par_PersonID, p.firstname, p.lastname, NULL, 'Consumer'
                FROM adventureworks_person.person AS p
                INNER JOIN adventureworks_sales.customer AS c
                    ON c.personid = p.businessentityid
                WHERE p.businessentityid = par_PersonID AND c.storeid IS NULL;
        END IF;
    END IF;
    RETURN QUERY
    SELECT
        *
        FROM ufngetcontactinformation$tmptbl;
    DROP TABLE IF EXISTS ufngetcontactinformation$tmptbl;
    RETURN;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetdocumentstatustext(IN par_status SMALLINT)
RETURNS VARCHAR
AS
$BODY$
/* Returns the sales order status text representation for the status value. */
DECLARE
    var_ret VARCHAR(16);
BEGIN
    var_ret :=
    CASE par_Status
        WHEN 1 THEN 'Pending approval'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Obsolete'
        ELSE '** Invalid **'
    END;
    RETURN var_ret;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetproductdealerprice(IN par_productid INTEGER, IN par_orderdate TIMESTAMP WITHOUT TIME ZONE)
RETURNS NUMERIC
AS
$BODY$
/* Returns the dealer price for the product on a specific date. */
DECLARE
    var_DealerPrice NUMERIC(19, 4);
    var_DealerDiscount NUMERIC(19, 4);
BEGIN
    var_DealerDiscount := 0.60;
    /* 60% of list price */
    SELECT
        plph.listprice * var_DealerDiscount
        INTO var_DealerPrice
        FROM adventureworks_production.product AS p
        INNER JOIN adventureworks_production.productlistpricehistory AS plph
            ON p.productid = plph.productid AND p.productid = par_ProductID AND par_OrderDate BETWEEN plph.startdate AND COALESCE(plph.enddate, aws_sqlserver_ext.conv_string_to_datetime('DATETIME', '99991231', 112));
    /* Make sure we get all the prices! */
    RETURN var_DealerPrice;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetproductlistprice(IN par_productid INTEGER, IN par_orderdate TIMESTAMP WITHOUT TIME ZONE)
RETURNS NUMERIC
AS
$BODY$
DECLARE
    var_ListPrice NUMERIC(19, 4);
BEGIN
    SELECT
        plph.listprice
        INTO var_ListPrice
        FROM adventureworks_production.product AS p
        INNER JOIN adventureworks_production.productlistpricehistory AS plph
            ON p.productid = plph.productid AND p.productid = par_ProductID AND par_OrderDate BETWEEN plph.startdate AND COALESCE(plph.enddate, aws_sqlserver_ext.conv_string_to_datetime('DATETIME', '99991231', 112));
    /* Make sure we get all the prices! */
    RETURN var_ListPrice;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetproductstandardcost(IN par_productid INTEGER, IN par_orderdate TIMESTAMP WITHOUT TIME ZONE)
RETURNS NUMERIC
AS
$BODY$
/* Returns the standard cost for the product on a specific date. */
DECLARE
    var_StandardCost NUMERIC(19, 4);
BEGIN
    SELECT
        pch.standardcost
        INTO var_StandardCost
        FROM adventureworks_production.product AS p
        INNER JOIN adventureworks_production.productcosthistory AS pch
            ON p.productid = pch.productid AND p.productid = par_ProductID AND par_OrderDate BETWEEN pch.startdate AND COALESCE(pch.enddate, aws_sqlserver_ext.conv_string_to_datetime('DATETIME', '99991231', 112));
    /* Make sure we get all the prices! */
    RETURN var_StandardCost;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetpurchaseorderstatustext(IN par_status SMALLINT)
RETURNS VARCHAR
AS
$BODY$
/* Returns the sales order status text representation for the status value. */
DECLARE
    var_ret VARCHAR(15);
BEGIN
    var_ret :=
    CASE par_Status
        WHEN 1 THEN 'Pending'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Rejected'
        WHEN 4 THEN 'Complete'
        ELSE '** Invalid **'
    END;
    RETURN var_ret;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetsalesorderstatustext(IN par_status SMALLINT)
RETURNS VARCHAR
AS
$BODY$
/* Returns the sales order status text representation for the status value. */
DECLARE
    var_ret VARCHAR(15);
BEGIN
    var_ret :=
    CASE par_Status
        WHEN 1 THEN 'In process'
        WHEN 2 THEN 'Approved'
        WHEN 3 THEN 'Backordered'
        WHEN 4 THEN 'Rejected'
        WHEN 5 THEN 'Shipped'
        WHEN 6 THEN 'Cancelled'
        ELSE '** Invalid **'
    END;
    RETURN var_ret;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufngetstock(IN par_productid INTEGER)
RETURNS INTEGER
AS
$BODY$
/* Returns the stock level for the product. This function is used internally only */
DECLARE
    var_ret INTEGER;
BEGIN
    SELECT
        SUM(p.quantity)
        INTO var_ret
        FROM adventureworks_production.productinventory AS p
        WHERE p.productid = par_ProductID AND p.locationid = '6';
    /* Only look at inventory in the misc storage */

    IF (var_ret IS NULL) THEN
        var_ret := 0;
    END IF;
    RETURN var_ret;
END;
$BODY$
LANGUAGE  plpgsql;



CREATE OR REPLACE FUNCTION adventureworks_dbo.ufnleadingzeros(IN par_value INTEGER)
RETURNS VARCHAR
AS
$BODY$
DECLARE
    var_ReturnValue VARCHAR(8);
BEGIN
    var_ReturnValue := CAST (par_Value AS VARCHAR(8));
    var_ReturnValue := REPEAT('0',
    CASE
        WHEN 8 - DATALENGTH(var_ReturnValue) < 0 THEN NULL::INT
        ELSE 8 - DATALENGTH(var_ReturnValue)
    END) || var_ReturnValue;
    RETURN (var_ReturnValue);
END;
$BODY$
LANGUAGE  plpgsql;



-- ------------ Write CREATE-PROCEDURE-stage scripts -----------

CREATE PROCEDURE adventureworks_dbo.uspgetbillofmaterials(IN par_startproductid INTEGER, IN par_checkdate TIMESTAMP WITHOUT TIME ZONE, INOUT p_refcur refcursor)
AS 
$BODY$
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    /* Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 */
    /* components of a level 0 assembly, all level 2 components of a level 1 assembly) */
    /* The CheckDate eliminates any components that are no longer used in the product on this date. */
    
    /*
    [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
    WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns
        AS (
            SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly
            FROM [Production].[BillOfMaterials] b
                INNER JOIN [Production].[Product] p
                ON b.[ComponentID] = p.[ProductID]
            WHERE b.[ProductAssemblyID] = @StartProductID
                AND @CheckDate >= b.[StartDate]
                AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
            UNION ALL
            SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor
            FROM [BOM_cte] cte
                INNER JOIN [Production].[BillOfMaterials] b
                ON b.[ProductAssemblyID] = cte.[ComponentID]
                INNER JOIN [Production].[Product] p
                ON b.[ComponentID] = p.[ProductID]
            WHERE @CheckDate >= b.[StartDate]
                AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
            )
        -- Outer select from the CTE
        SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
        FROM [BOM_cte] b
        GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
        ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
        OPTION (MAXRECURSION 25)
    */
    BEGIN
    END;
END;
$BODY$
LANGUAGE plpgsql;



CREATE PROCEDURE adventureworks_dbo.uspgetemployeemanagers(IN par_businessentityid INTEGER, INOUT p_refcur refcursor)
AS 
$BODY$
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    /* Use recursive query to list out all Employees required for a particular Manager */
    
    /*
    [7708 - Severity CRITICAL - Unable convert complex usage of unsupported HIERARCHYID.GETANCESTOR(INT) datatype. Perform a manual conversion., 7708 - Severity CRITICAL - Unable convert complex usage of unsupported HIERARCHYID.TOSTRING() datatype. Perform a manual conversion., 7708 - Severity CRITICAL - Unable convert complex usage of unsupported HIERARCHYID.GETANCESTOR(INT) datatype. Perform a manual conversion., 7708 - Severity CRITICAL - Unable convert complex usage of unsupported HIERARCHYID.TOSTRING() datatype. Perform a manual conversion.]
    WITH [EMP_cte]([BusinessEntityID], [OrganizationNode], [FirstName], [LastName], [JobTitle], [RecursionLevel]) -- CTE name and columns
        AS (
            SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], e.[JobTitle], 0 -- Get the initial Employee
            FROM [HumanResources].[Employee] e
    			INNER JOIN [Person].[Person] as p
    			ON p.[BusinessEntityID] = e.[BusinessEntityID]
            WHERE e.[BusinessEntityID] = @BusinessEntityID
            UNION ALL
            SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], e.[JobTitle], [RecursionLevel] + 1 -- Join recursive member to anchor
            FROM [HumanResources].[Employee] e
                INNER JOIN [EMP_cte]
                ON e.[OrganizationNode] = [EMP_cte].[OrganizationNode].GetAncestor(1)
                INNER JOIN [Person].[Person] p
                ON p.[BusinessEntityID] = e.[BusinessEntityID]
        )
        -- Join back to Employee to return the manager name
        SELECT [EMP_cte].[RecursionLevel], [EMP_cte].[BusinessEntityID], [EMP_cte].[FirstName], [EMP_cte].[LastName],
            [EMP_cte].[OrganizationNode].ToString() AS [OrganizationNode], p.[FirstName] AS 'ManagerFirstName', p.[LastName] AS 'ManagerLastName'  -- Outer select from the CTE
        FROM [EMP_cte]
            INNER JOIN [HumanResources].[Employee] e
            ON [EMP_cte].[OrganizationNode].GetAncestor(1) = e.[OrganizationNode]
            INNER JOIN [Person].[Person] p
            ON p.[BusinessEntityID] = e.[BusinessEntityID]
        ORDER BY [RecursionLevel], [EMP_cte].[OrganizationNode].ToString()
        OPTION (MAXRECURSION 25)
    */
    BEGIN
    END;
END;
$BODY$
LANGUAGE plpgsql;



CREATE PROCEDURE adventureworks_dbo.uspgetmanageremployees(IN par_businessentityid INTEGER, INOUT p_refcur refcursor)
AS 
$BODY$
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    /* Use recursive query to list out all Employees required for a particular Manager */
    
    /*
    [7708 - Severity CRITICAL - Unable convert complex usage of unsupported HIERARCHYID.GETANCESTOR(INT) datatype. Perform a manual conversion., 7708 - Severity CRITICAL - Unable convert complex usage of unsupported HIERARCHYID.TOSTRING() datatype. Perform a manual conversion., 7708 - Severity CRITICAL - Unable convert complex usage of unsupported HIERARCHYID.GETANCESTOR(INT) datatype. Perform a manual conversion., 7708 - Severity CRITICAL - Unable convert complex usage of unsupported HIERARCHYID.TOSTRING() datatype. Perform a manual conversion.]
    WITH [EMP_cte]([BusinessEntityID], [OrganizationNode], [FirstName], [LastName], [RecursionLevel]) -- CTE name and columns
        AS (
            SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], 0 -- Get the initial list of Employees for Manager n
            FROM [HumanResources].[Employee] e
    			INNER JOIN [Person].[Person] p
    			ON p.[BusinessEntityID] = e.[BusinessEntityID]
            WHERE e.[BusinessEntityID] = @BusinessEntityID
            UNION ALL
            SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], [RecursionLevel] + 1 -- Join recursive member to anchor
            FROM [HumanResources].[Employee] e
                INNER JOIN [EMP_cte]
                ON e.[OrganizationNode].GetAncestor(1) = [EMP_cte].[OrganizationNode]
    			INNER JOIN [Person].[Person] p
    			ON p.[BusinessEntityID] = e.[BusinessEntityID]
            )
        -- Join back to Employee to return the manager name
        SELECT [EMP_cte].[RecursionLevel], [EMP_cte].[OrganizationNode].ToString() as [OrganizationNode], p.[FirstName] AS 'ManagerFirstName', p.[LastName] AS 'ManagerLastName',
            [EMP_cte].[BusinessEntityID], [EMP_cte].[FirstName], [EMP_cte].[LastName] -- Outer select from the CTE
        FROM [EMP_cte]
            INNER JOIN [HumanResources].[Employee] e
            ON [EMP_cte].[OrganizationNode].GetAncestor(1) = e.[OrganizationNode]
    			INNER JOIN [Person].[Person] p
    			ON p.[BusinessEntityID] = e.[BusinessEntityID]
        ORDER BY [RecursionLevel], [EMP_cte].[OrganizationNode].ToString()
        OPTION (MAXRECURSION 25)
    */
    BEGIN
    END;
END;
$BODY$
LANGUAGE plpgsql;



CREATE PROCEDURE adventureworks_dbo.uspgetwhereusedproductid(IN par_startproductid INTEGER, IN par_checkdate TIMESTAMP WITHOUT TIME ZONE, INOUT p_refcur refcursor)
AS 
$BODY$
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    /* Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 components of a level 0 assembly, all level 2 components of a level 1 assembly) */
    
    /*
    [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
    WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns
        AS (
            SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly
            FROM [Production].[BillOfMaterials] b
                INNER JOIN [Production].[Product] p
                ON b.[ProductAssemblyID] = p.[ProductID]
            WHERE b.[ComponentID] = @StartProductID
                AND @CheckDate >= b.[StartDate]
                AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
            UNION ALL
            SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor
            FROM [BOM_cte] cte
                INNER JOIN [Production].[BillOfMaterials] b
                ON cte.[ProductAssemblyID] = b.[ComponentID]
                INNER JOIN [Production].[Product] p
                ON b.[ProductAssemblyID] = p.[ProductID]
            WHERE @CheckDate >= b.[StartDate]
                AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
            )
        -- Outer select from the CTE
        SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
        FROM [BOM_cte] b
        GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
        ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
        OPTION (MAXRECURSION 25)
    */
    BEGIN
    END;
END;
$BODY$
LANGUAGE plpgsql;



CREATE PROCEDURE adventureworks_dbo.usplogerror(INOUT par_errorlogid INTEGER DEFAULT 0, INOUT return_code int)
AS 
$BODY$
/* uspLogError logs error information in the ErrorLog table about the */
/* error that caused execution to jump to the CATCH block of a */
/* TRY...CATCH construct. This should be executed from within the scope */
/* of a CATCH block otherwise it will return without inserting error */
/* information. */
/* contains the ErrorLogID of the row inserted */
/* by uspLogError in the ErrorLog table */
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    /* Output parameter value of 0 indicates that error */
    /* information was not logged */
    par_ErrorLogID := 0;

    BEGIN
        /* Return if there is no error information to log */
        IF error_catch$ERROR_NUMBER IS NULL THEN
            RETURN;
        END IF;
        /* Return if inside an uncommittable transaction. */
        /* Data insertion/modification is not allowed when */
        /* a transaction is in an uncommittable state. */

        IF xact_state() = - 1 THEN
            RAISE NOTICE '%', 'Cannot log error since the current transaction is in an uncommittable state. ' || 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END IF;
        /*
        [7811 - Severity CRITICAL - PostgreSQL doesn't support the CURRENT_USER() function. Create a user-defined function.]
        INSERT [dbo].[ErrorLog]
                    (
                    [UserName],
                    [ErrorNumber],
                    [ErrorSeverity],
                    [ErrorState],
                    [ErrorProcedure],
                    [ErrorLine],
                    [ErrorMessage]
                    )
                VALUES
                    (
                    CONVERT(sysname, CURRENT_USER),
                    ERROR_NUMBER(),
                    ERROR_SEVERITY(),
                    ERROR_STATE(),
                    ERROR_PROCEDURE(),
                    ERROR_LINE(),
                    ERROR_MESSAGE()
                    );
        */
        /* Pass back the ErrorLogID of the row inserted */
        par_ErrorLogID := LASTVAL();
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'An error occurred in stored procedure uspLogError: ';
                CALL adventureworks_dbo.uspprinterror();
                return_code := - 1;
                RETURN;
    END;
END;
$BODY$
LANGUAGE plpgsql;



CREATE PROCEDURE adventureworks_dbo.uspprinterror()
AS 
$BODY$
/* uspPrintError prints error information about the error that caused */
/* execution to jump to the CATCH block of a TRY...CATCH construct. */
/* Should be executed from within the scope of a CATCH block otherwise */
/* it will return without printing any error information. */
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    /* Print error information. */
    RAISE NOTICE '%', 'Error ' || CAST (error_catch$ERROR_NUMBER AS VARCHAR(50)) || ', Severity ' || CAST (error_catch$ERROR_SEVERITY AS VARCHAR(5)) || ', State ' || CAST (error_catch$ERROR_STATE AS VARCHAR(5)) || ', Procedure ' || COALESCE(error_catch$ERROR_PROCEDURE, '-') || ', Line ' || CAST (error_catch$ERROR_LINE AS VARCHAR(5));
    RAISE NOTICE '%', error_catch$ERROR_MESSAGE;
END;
$BODY$
LANGUAGE plpgsql;



CREATE PROCEDURE adventureworks_dbo.uspsearchcandidateresumes(IN par_searchstring VARCHAR, IN par_useinflectional NUMERIC DEFAULT 0, IN par_usethesaurus NUMERIC DEFAULT 0, IN par_language INTEGER DEFAULT 0, INOUT p_refcur refcursor DEFAULT NULL, INOUT p_refcur_2 refcursor DEFAULT NULL, INOUT p_refcur_3 refcursor DEFAULT NULL, INOUT p_refcur_4 refcursor DEFAULT NULL)
AS 
$BODY$
/* A stored procedure which demonstrates integrated full text search */
DECLARE
    var_string VARCHAR(1050);
BEGIN
    /*
    [7810 - Severity CRITICAL - PostgreSQL doesn't support the SET NOCOUNT. If need try another way to send message back to the client application.]
    SET NOCOUNT ON;
    */
    /* setting the lcid to the default instance LCID if needed */
    IF par_language = NULL OR par_language = 0 THEN
        /*
        [7708 - Severity CRITICAL - Unable convert complex usage of unsupported SQL_VARIANT datatype. Perform a manual conversion.]
        SELECT @language =CONVERT(int, serverproperty('lcid'))
        */
        BEGIN
        END;
    END IF;
    /* FREETEXTTABLE case as inflectional and Thesaurus were required */

    IF par_useThesaurus = 1 AND par_useInflectional = 1 THEN
        /*
        [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
        SELECT FT_TBL.[JobCandidateID], KEY_TBL.[RANK] FROM [HumanResources].[JobCandidate] AS FT_TBL
                                INNER JOIN FREETEXTTABLE([HumanResources].[JobCandidate],*, @searchString,LANGUAGE @language) AS KEY_TBL
                           ON  FT_TBL.[JobCandidateID] =KEY_TBL.[KEY]
        */
        BEGIN
        END;
    ELSE
        IF par_useThesaurus = 1 THEN
            SELECT
                'FORMSOF(THESAURUS,"' || par_searchString || '"' || ')'
                INTO var_string;
            /*
            [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
            SELECT FT_TBL.[JobCandidateID], KEY_TBL.[RANK] FROM [HumanResources].[JobCandidate] AS FT_TBL
                                    INNER JOIN CONTAINSTABLE([HumanResources].[JobCandidate],*, @string,LANGUAGE @language) AS KEY_TBL
                               ON  FT_TBL.[JobCandidateID] =KEY_TBL.[KEY]
            */
        ELSE
            IF par_useInflectional = 1 THEN
                SELECT
                    'FORMSOF(INFLECTIONAL,"' || par_searchString || '"' || ')'
                    INTO var_string;
                /*
                [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
                SELECT FT_TBL.[JobCandidateID], KEY_TBL.[RANK] FROM [HumanResources].[JobCandidate] AS FT_TBL
                                        INNER JOIN CONTAINSTABLE([HumanResources].[JobCandidate],*, @string,LANGUAGE @language) AS KEY_TBL
                                   ON  FT_TBL.[JobCandidateID] =KEY_TBL.[KEY]
                */
            ELSE
                /* base case, plain CONTAINSTABLE */
                SELECT
                    '"' || par_searchString || '"'
                    INTO var_string;
                /*
                [9996 - Severity CRITICAL - Transformer error occurred. Please submit report to developers.]
                SELECT FT_TBL.[JobCandidateID],KEY_TBL.[RANK] FROM [HumanResources].[JobCandidate] AS FT_TBL
                                        INNER JOIN CONTAINSTABLE([HumanResources].[JobCandidate],*,@string,LANGUAGE @language) AS KEY_TBL
                                   ON  FT_TBL.[JobCandidateID] =KEY_TBL.[KEY]
                */
            END IF;
        END IF;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;



