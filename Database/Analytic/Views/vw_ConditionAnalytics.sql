USE HospitalPatientDb;
GO

CREATE OR ALTER VIEW analytic.vw_ConditionAnalytics
AS
SELECT dc.Name AS Condition,
    COUNT(*) AS EncounterCount,
    CAST(SUM(Cost) AS DECIMAL(10, 2)) AS TotalCost,
    CAST(AVG(Cost) AS DECIMAL(10, 2)) AS AverageCost,
    CAST(AVG(CAST(LengthOfStay AS DECIMAL(10, 2))) AS DECIMAL(10, 2)) AS AvgLengthOfStay,
    CAST(AVG(CAST(Satisfaction AS DECIMAL(10, 2))) AS DECIMAL(10, 2)) AS AvgSatisfaction
FROM warehouse.FactPatientEncounter AS fp
     JOIN warehouse.DimCondition AS dc
          ON fp.ConditionId = dc.ConditionId
GROUP BY dc.Name;
GO

SELECT *
FROM analytic.vw_ConditionAnalytics;

