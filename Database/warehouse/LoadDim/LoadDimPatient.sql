CREATE OR ALTER PROCEDURE LoadDimPatient
AS
BEGIN
    INSERT INTO warehouse.DimPatient
        (SourcePatientId, Age, Gender)
    SELECT PatientId, Age, Gender
    FROM staging.Patient AS sp
    WHERE NOT EXISTS (SELECT 1
    FROM warehouse.DimPatient AS wp
    WHERE wp.SourcePatientId = sp.PatientId)
END;
GO

