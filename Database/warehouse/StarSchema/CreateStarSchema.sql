USE HospitalPatientDb;
GO

-- Create Patient table
CREATE TABLE warehouse.DimPatient
(
    PatientId INT PRIMARY KEY IDENTITY (1,1),
    SourcePatientId INT UNIQUE NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(30) NOT NULL
);

-- Create Condition Table
CREATE TABLE warehouse.DimCondition
(
    ConditionId INT PRIMARY KEY IDENTITY (1,1),
    Name VARCHAR(100) NOT NULL UNIQUE
);

-- Create Procedure table
CREATE TABLE warehouse.DimProcedure
(
    ProcedureId INT PRIMARY KEY IDENTITY (1,1),
    Name VARCHAR(255) NOT NULL UNIQUE
);

-- Create Outcome table
CREATE TABLE warehouse.DimOutcome
(
    OutcomeId INT PRIMARY KEY IDENTITY (1,1),
    Name VARCHAR(100) NOT NULL
);

-- Create Fact table
CREATE TABLE warehouse.FactPatientEncounter
(
    PatientFactId INT PRIMARY KEY IDENTITY (1,1),
    PatientId INT NOT NULL,
    ConditionId INT NOT NULL,
    ProcedureId INT NOT NULL,
    OutcomeId INT NOT NULL,
    Cost DECIMAL(18, 2) NOT NULL,
    LengthOfStay INT NOT NULL,
    Readmission VARCHAR(10) NOT NULL,
    Satisfaction INT NOT NULL,
    FOREIGN KEY (PatientId) REFERENCES warehouse.DimPatient (PatientId),
    FOREIGN KEY (ConditionId) REFERENCES warehouse.DimCondition (ConditionId),
    FOREIGN KEY (ProcedureId) REFERENCES warehouse.DimProcedure (ProcedureId),
    FOREIGN KEY (OutcomeId) REFERENCES warehouse.DimOutcome (OutcomeId)
);

-- Check if table is created
CREATE OR ALTER PROCEDURE CheckTableExists(
    @p_SchemaName VARCHAR(100),
    @p_TableName VARCHAR(100)
)
AS
BEGIN
    IF NOT EXISTS(SELECT 1
    FROM sys.tables
    WHERE name = @p_SchemaName + '.' + @p_TableName)
        BEGIN
            PRINT @p_SchemaName + '.' + @p_TableName + ' exists.'
        END
    ELSE
        BEGIN
            PRINT @p_SchemaName + '.' + @p_TableName + ' does not exists.'
        END
END;
GO

EXEC CheckTableExists @p_SchemaName = 'warehouse', @p_TableName = 'DimPatient';

EXEC CheckTableExists @p_SchemaName = 'warehouse', @p_TableName = 'DimCondition';

EXEC CheckTableExists @p_SchemaName = 'warehouse', @p_TableName = 'DimProcedure';

EXEC CheckTableExists @p_SchemaName = 'warehouse', @p_TableName = 'DimOutcome';

EXEC CheckTableExists @p_SchemaName = 'warehouse', @p_TableName = 'FactPatientEncounter';