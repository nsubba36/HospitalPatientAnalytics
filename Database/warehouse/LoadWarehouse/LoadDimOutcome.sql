USE HospitalPatientDb;
GO

CREATE OR ALTER PROCEDURE warehouse.LoadDimOutcome
AS
BEGIN
    INSERT INTO warehouse.DimOutcome
        (Name)
    SELECT DISTINCT s.Outcome
    FROM staging.Patient AS s
    WHERE NOT EXISTS (SELECT 1
    FROM warehouse.DimOutcome AS w
    WHERE w.Name = s.Outcome);
END;
GO

EXEC warehouse.LoadDimOutcome;

-- Test to see if row is inserted
CREATE OR ALTER PROCEDURE warehouse.Test_LoadDimOutcome
AS
DECLARE
    @v_OriginalCount INT,
    @v_NewCount      INT;
BEGIN
    SELECT @v_OriginalCount = COUNT(DISTINCT Outcome)
    FROM staging.Patient;

    SELECT @v_NewCount = COUNT(*)
    FROM warehouse.DimOutcome;

    PRINT CONCAT('The original count: ', @v_OriginalCount);
    PRINT CONCAT('The new count: ', @v_NewCount);

    IF @v_OriginalCount = @v_NewCount
        BEGIN
            PRINT 'All rows successfully inserted.'
        END
    ELSE
        BEGIN
            PRINT 'Something went wrong with data load to DimOutcome.'
        END
END;
GO

SELECT DISTINCT Outcome
FROM staging.Patient;

SELECT *
FROM warehouse.DimOutcome;

EXEC warehouse.Test_LoadDimOutcome;