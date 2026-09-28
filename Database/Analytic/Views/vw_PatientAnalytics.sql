USE HospitalPatientDb;
GO

CREATE OR ALTER VIEW analytic.vw_PatientAnalytics
AS
SELECT dp.PatientId,
    dp.SourcePatientId,
    dp.Age,
    dp.Gender,
    dc.Name AS ConditionName,
    dpr.Name AS ProcedureName,
    do.Name AS Outcome,
    fp.Cost,
    fp.LengthOfStay,
    fp.Readmission,
    fp.Satisfaction
FROM warehouse.FactPatientEncounter AS fp
     JOIN warehouse.DimPatient AS dp
          ON fp.PatientId = dp.PatientId
     JOIN warehouse.DimCondition AS dc
          ON fp.ConditionId = dc.ConditionId
     JOIN warehouse.DimProcedure AS dpr
          ON fp.ProcedureId = dpr.ProcedureId
     JOIN warehouse.DimOutcome AS do
          ON fp.OutcomeId = do.OutcomeId;
GO

SELECT *
FROM analytic.vw_PatientAnalytics;