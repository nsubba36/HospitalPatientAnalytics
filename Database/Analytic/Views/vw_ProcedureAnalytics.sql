USE HospitalPatientDb;
GO

CREATE OR ALTER VIEW analytic.vw_ProcedureAnalytics
AS
SELECT dp.Name AS ProcedureName,
    COUNT(*) AS EncounterCount,
    CAST(SUM(Cost) AS DECIMAL(10, 2)) AS TotalCost,
    CAST(AVG(Cost) AS DECIMAL(10, 2)) AS AverageCost,
    CAST(AVG(CAST(LengthOfStay AS DECIMAL(10, 2))) AS DECIMAL(10, 2)) AS AvgLengthOfStay,
    CAST(AVG(CAST(Satisfaction AS DECIMAL(10, 2))) AS DECIMAL(10, 2)) AS AvgSatisfaction
FROM warehouse.FactPatientEncounter AS fp
     JOIN warehouse.DimProcedure AS dp
          ON fp.ProcedureId = dp.ProcedureId
GROUP BY dp.Name;
GO

SELECT *
FROM analytic.vw_ProcedureAnalytics;