-- Create Warehouse and Analytics schema

USE HospitalPatientDb;
GO

CREATE OR ALTER PROCEDURE CreateSchema(@p_SchemaName VARCHAR(50))
AS
BEGIN
    IF @p_SchemaName IS NULL OR TRIM(@p_SchemaName) = ''
        BEGIN
            PRINT 'schema name is null. please try again';
            RETURN;
        END

    IF NOT EXISTS(SELECT *
    FROM sys.schemas
    WHERE name = @p_SchemaName)
        BEGIN
            DECLARE @sql NVARCHAR(MAX);
            SET @sql = 'CREATE SCHEMA ' + QUOTENAME(@p_SchemaName) + ';';
            EXEC (@sql);
        END
    ELSE
        BEGIN
            PRINT @p_SchemaName + ' schema already exists;'
            RETURN;
        END
    PRINT @p_SchemaName + ' schema created successfully;'
END;
GO

-- Create warehouse schema
EXEC CreateSchema @p_SchemaName = 'warehouse';

-- Create analytic schema
EXEC CreateSchema @p_SchemaName = 'analytic';


