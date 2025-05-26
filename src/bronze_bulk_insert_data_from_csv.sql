-- This script copies data from csv to bronze layer Insurance table
-- MySQL uses BULK INSERT, Postgres uses COPY
-- Remember to put the correct path

-- First TRUNCATE, in order to do FULL LOAD of the csv, if new data arrive.
TRUNCATE TABLE bronze.Insurance;

COPY bronze.Insurance(
    ID, Insurance_Coverage_Days, Insured_Age, Insured_Sex, Insured_Status, Insured_NoClaimYears,
    Insured_CreditScore, Insured_RegionID, Insured_DriveArea, Car_Use, Car_Age, AnnualDrive_km,
    TotDrive_km, Drive_Avgdays_week, Drive_TimeOnRoad_pct, Drive_Mon_pct, Drive_Tue_pct,
    Drive_Wed_pct, Drive_Thr_pct, Drive_Fri_pct, Drive_Sat_pct, Drive_Sun_pct, Drive_2hrs_pct,
    Drive_3hrs_pct, Drive_4hrs_pct, Drive_Wkday_pct, Drive_Wkend_pct, Drive_RushAM_pct,
    Drive_RushPM_pct, Accel_03ms2_1000km, Accel_04ms2_1000km, Accel_05ms2_1000km,
    Accel_06ms2_1000km, Accel_07ms2_1000km, Brake_03ms2_1000km, Brake_04ms2_1000km,
    Brake_05ms2_1000km, Brake_06ms2_1000km, Brake_07ms2_1000km, LeftTurn_Low_1000km,
    LeftTurn_Med_1000km, LeftTurn_High_1000km, RightTurn_Low_1000km, RightTurn_Med_1000km,
    RightTurn_High_1000km, AMT_Claim, NB_Claim
)
FROM '/Users/diego/End-To-End-ML-pipeline-for-profiling-insurance-customers/data/raw/historic_dataset.csv'
DELIMITER ','
CSV HEADER;
