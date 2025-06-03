-- The correct syntax in PostgreSQL is the following, not IF OBJECT_ID (...) EXISTS etc.
--docker exec -i f4207a7817b3 psql -U postgres -d postgres < silver_create_table.sql 
--\connect datawarehouse;
DROP TABLE IF EXISTS silver.insurance;
CREATE SCHEMA IF NOT EXISTS silver;

CREATE TABLE silver.insurance AS
SELECT
    ID,
    Insurance_Coverage_Days,
    Insured_Age,

    CASE Insured_Sex
        WHEN 'Male' THEN 0
        WHEN 'Female' THEN 1
        ELSE NULL
    END AS Insured_Sex,

    CASE Insured_Status
        WHEN 'Single' THEN 0
        WHEN 'Married' THEN 1
        ELSE NULL
    END AS Insured_Status,

    Insured_NoClaimYears,
    Insured_CreditScore,
    Insured_RegionID,

    CASE Insured_DriveArea
        WHEN 'Urban' THEN 0
        WHEN 'Rural' THEN 1
        ELSE NULL
    END AS Insured_DriveArea,

    CASE Car_Use
        WHEN 'Commercial' THEN 0
        WHEN 'Commute' THEN 1
        WHEN 'Farmer' THEN 2
        WHEN 'Private' THEN 3
        ELSE NULL
    END AS Car_Use,

    Car_Age,
    AnnualDrive_km,
    TotDrive_km
    Drive_Avgdays_week,
    Drive_TimeOnRoad_pct,
    Drive_Mon_pct,
    Drive_Tue_pct,
    Drive_Wed_pct,
    Drive_Thr_pct,
    Drive_Fri_pct,
    Drive_Sat_pct,
    Drive_Sun_pct,
    Drive_2hrs_pct,
    Drive_3hrs_pct,
    Drive_4hrs_pct,
    Drive_Wkday_pct,
    Drive_Wkend_pct,
    Drive_RushAM_pct,
    Drive_RushPM_pct,
    Accel_03ms2_1000km,
    Accel_04ms2_1000km,
    Accel_05ms2_1000km,
    Accel_06ms2_1000km,
    Accel_07ms2_1000km,
    Brake_03ms2_1000km,
    Brake_04ms2_1000km,
    Brake_05ms2_1000km,
    Brake_06ms2_1000km,
    Brake_07ms2_1000km,
    LeftTurn_Low_1000km,
    LeftTurn_Med_1000km,
    LeftTurn_High_1000km,
    RightTurn_Low_1000km,
    RightTurn_Med_1000km,
    RightTurn_High_1000km,
    AMT_Claim,
    NB_Claim,
    CURRENT_TIMESTAMP AT TIME ZONE 'UTC' AS dwh_create_data  -- This column is used to track when the record was created in the data warehouse

FROM bronze.insurance;