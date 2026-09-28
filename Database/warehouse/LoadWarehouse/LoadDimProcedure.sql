USE HospitalPatientDb;
GO

CREATE OR ALTER PROCEDURE warehouse.LoadDimProcedure
AS
BEGIN
    INSERT INTO warehouse.DimProcedure
        (Name)
    SELECT DISTINCT s.ProcedureName
    FROM staging.Patient AS s
    WHERE NOT EXISTS (SELECT 1
    FROM warehouse.DimProcedure AS w
    WHERE w.Name = s.ProcedureName);
END;
GO

EXEC warehouse.LoadDimProcedure;

-- Test to see if row is inserted
CREATE OR ALTER PROCEDURE warehouse.Test_LoadDimProcedure
AS
DECLARE
    @v_OriginalCount INT,
    @v_NewCount      INT;
BEGIN
    SELECT @v_OriginalCount = COUNT(DISTINCT ProcedureName)
    FROM staging.Patient;

    SELECT @v_NewCount = COUNT(*)
    FROM warehouse.DimProcedure;

    PRINT CONCAT('The original count: ', @v_OriginalCount);
    PRINT CONCAT('The new count: ', @v_NewCount);

    IF @v_OriginalCount = @v_NewCount
        BEGIN
            PRINT 'All rows successfully inserted.'
        END
    ELSE
        BEGIN
            PRINT 'Something went wrong with data load to DimProcedure.'
        END
END;
GO

SELECT DISTINCT ProcedureName
FROM staging.Patient;

SELECT *
FROM warehouse.DimProcedure;

EXEC warehouse.Test_LoadDimProcedure;
