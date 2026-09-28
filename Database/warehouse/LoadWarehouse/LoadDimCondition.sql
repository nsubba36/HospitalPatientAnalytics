USE HospitalPatientDb;
GO

CREATE OR ALTER PROCEDURE warehouse.LoadDimCondition
AS
BEGIN
    INSERT INTO warehouse.DimCondition
        (Name)
    SELECT DISTINCT s.Condition
    FROM staging.Patient AS s
    WHERE NOT EXISTS (SELECT 1
    FROM warehouse.DimCondition AS w
    WHERE w.Name = s.Condition);
END;
GO

EXEC warehouse.LoadDimCondition;

-- Test to see if row is inserted
CREATE OR ALTER PROCEDURE warehouse.Test_LoadDimCondition
AS
DECLARE
    @v_OriginalCount INT,
    @v_NewCount      INT;
BEGIN
    SELECT @v_OriginalCount = COUNT(DISTINCT Condition)
    FROM staging.Patient;

    SELECT @v_NewCount = COUNT(*)
    FROM warehouse.DimCondition;

    PRINT CONCAT('The original count: ', @v_OriginalCount);
    PRINT CONCAT('The new count: ', @v_NewCount);

    IF @v_OriginalCount = @v_NewCount
        BEGIN
            PRINT 'All rows successfully inserted.'
        END
    ELSE
        BEGIN
            PRINT 'Something went wrong with data load to DimCondition.'
        END
END;
GO

SELECT DISTINCT condition
FROM staging.Patient;

SELECT *
FROM warehouse.DimCondition;

EXEC warehouse.Test_LoadDimCondition;