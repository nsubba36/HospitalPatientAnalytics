USE HospitalPatientDb;
GO

CREATE OR ALTER PROCEDURE warehouse.LoadDimPatient
AS
BEGIN
    INSERT INTO warehouse.DimPatient
        (SourcePatientId, Age, Gender)
    SELECT sp.PatientId, sp.Age, sp.Gender
    FROM staging.Patient AS sp
    WHERE NOT EXISTS (SELECT 1
    FROM warehouse.DimPatient AS wp
    WHERE wp.SourcePatientId = sp.PatientId)
END;
GO

EXEC warehouse.LoadDimPatient;

SELECT *
FROM warehouse.DimPatient;

-- Test to see if row is inserted
CREATE OR ALTER PROCEDURE warehouse.Test_LoadDimPatient
AS
DECLARE
    @v_OriginalCount INT,
    @v_NewCount      INT;
BEGIN
    SELECT @v_OriginalCount = COUNT(*)
    FROM staging.Patient;

    SELECT @v_NewCount = COUNT(*)
    FROM warehouse.DimPatient;

    IF @v_OriginalCount = @v_NewCount
        BEGIN
            PRINT 'All rows successfully inserted.'
        END
    ELSE
        BEGIN
            PRINT 'Something went wrong with data load to DimPatient.'
        END
END;
GO

EXEC warehouse.Test_LoadDimPatient;