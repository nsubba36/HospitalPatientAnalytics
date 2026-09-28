USE HospitalPatientDb;
GO

CREATE OR ALTER PROCEDURE warehouse.LoadFactPatientEncounter
AS
BEGIN
    INSERT INTO warehouse.FactPatientEncounter
    (PatientId, ConditionId, ProcedureId, OutcomeId, Cost, LengthOfStay, Readmission, Satisfaction)
    SELECT dp.PatientId, dc.ConditionId, dpr.ProcedureId, do.OutcomeId, sp.Cost, sp.LengthOfStay, sp.Readmission,
        sp.Satisfaction
    FROM staging.Patient AS sp
         JOIN warehouse.DimPatient AS dp
              ON sp.PatientId = dp.SourcePatientId
         JOIN warehouse.DimCondition dc
              ON dc.Name = sp.Condition
         JOIN warehouse.DimProcedure dpr
              ON dpr.Name = sp.ProcedureName
         JOIN warehouse.DimOutcome do
              ON do.Name = sp.Outcome
    WHERE NOT EXISTS(SELECT 1
    FROM warehouse.FactPatientEncounter AS fp
    WHERE fp.PatientId = dp.PatientId);
END;
GO

EXEC warehouse.LoadFactPatientEncounter;

SELECT COUNT(*)
FROM warehouse.FactPatientEncounter;

-- The data was not inserted
-- I accidentally made a mistake when I was writing script for LoadDimProcedure. I inserted Condition name instead of
-- Procedure name. I had to take out my select statement from tsql and run it separately.
-- When I ran that query, it showed 0 rows, so it was something wrong with my select statement
-- Since I had no idea what could be wrong, I had to individually run each select query one at a time and join table one at a time
-- Once I got to joining DimProcedure that I saw what was wrong.

SELECT *
FROM warehouse.FactPatientEncounter;

SELECT dp.PatientId, dc.ConditionId, dpr.ProcedureId, do.OutcomeId, sp.Cost, sp.LengthOfStay, sp.Readmission,
    sp.Satisfaction
FROM staging.Patient AS sp
     JOIN warehouse.DimPatient AS dp
          ON sp.PatientId = dp.SourcePatientId
     JOIN warehouse.DimCondition dc
          ON dc.Name = sp.Condition
     JOIN warehouse.DimProcedure dpr
          ON dpr.Name = sp.ProcedureName
     JOIN warehouse.DimOutcome do
          ON do.Name = sp.Outcome;

SELECT *
FROM staging.Patient AS sp;

SELECT *
FROM staging.Patient AS sp
     JOIN warehouse.DimPatient AS dp
          ON sp.PatientId = dp.SourcePatientId;

SELECT *
FROM staging.Patient AS sp
     JOIN warehouse.DimPatient AS dp
          ON sp.PatientId = dp.SourcePatientId
     JOIN warehouse.DimCondition AS dc
          ON dc.Name = sp.Condition;

SELECT *
FROM staging.Patient AS sp
     JOIN warehouse.DimPatient AS dp
          ON sp.PatientId = dp.SourcePatientId
     JOIN warehouse.DimCondition AS dc
          ON dc.Name = sp.Condition
     JOIN warehouse.DimProcedure AS dpr
          ON dpr.Name = sp.ProcedureName;

SELECT *
FROM warehouse.DimCondition;
SELECT *
FROM warehouse.DimProcedure;


-- Test to see if row is inserted
CREATE OR ALTER PROCEDURE warehouse.Test_LoadFactPatientEncounter
AS
DECLARE
    @v_OriginalCount INT,
    @v_NewCount      INT;
BEGIN
    SELECT @v_OriginalCount = COUNT(*)
    FROM staging.Patient;

    SELECT @v_NewCount = COUNT(*)
    FROM warehouse.FactPatientEncounter;

    PRINT CONCAT('The original count: ', @v_OriginalCount);
    PRINT CONCAT('The new count: ', @v_NewCount);

    IF @v_OriginalCount = @v_NewCount
        BEGIN
            PRINT 'All rows successfully inserted.'
        END
    ELSE
        BEGIN
            PRINT 'Something went wrong with data load to FactPatientEncounter.'
        END
END;
GO

SELECT DISTINCT Outcome
FROM staging.Patient;

SELECT *
FROM warehouse.FactPatientEncounter;

EXEC warehouse.Test_LoadFactPatientEncounter;