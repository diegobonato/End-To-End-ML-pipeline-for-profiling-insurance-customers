-- The correct syntax in PostgreSQL is the following, not IF OBJECT_ID (...) EXISTS etc.

-- Connect to the db
--\connect datawarehouse;

CREATE SCHEMA IF NOT EXISTS bronze;

DROP TABLE IF EXISTS bronze.insurance;

CREATE TABLE bronze.insurance (
    ID                          INTEGER PRIMARY KEY,
    Insurance_Coverage_Days     INTEGER,
    Insured_Age                 INTEGER,
    Insured_Sex                 TEXT,
    Insured_Status              TEXT,
    Insured_NoClaimYears        INTEGER,
    Insured_CreditScore         INTEGER,
    Insured_RegionID            INTEGER,
    Insured_DriveArea           TEXT,
    Car_Use                     TEXT,
    Car_Age                     INTEGER,
    AnnualDrive_km              INTEGER,
    TotDrive_km                 INTEGER,
    Drive_Avgdays_week          REAL,
    Drive_TimeOnRoad_pct        REAL,
    Drive_Mon_pct               REAL,
    Drive_Tue_pct               REAL,
    Drive_Wed_pct               REAL,
    Drive_Thr_pct               REAL,
    Drive_Fri_pct               REAL,
    Drive_Sat_pct               REAL,
    Drive_Sun_pct               REAL,
    Drive_2hrs_pct              REAL,
    Drive_3hrs_pct              REAL,
    Drive_4hrs_pct              REAL,
    Drive_Wkday_pct             REAL,
    Drive_Wkend_pct             REAL,
    Drive_RushAM_pct            REAL,
    Drive_RushPM_pct            REAL,
    Accel_03ms2_1000km          INTEGER,
    Accel_04ms2_1000km          INTEGER,
    Accel_05ms2_1000km          INTEGER,
    Accel_06ms2_1000km          INTEGER,
    Accel_07ms2_1000km          INTEGER,
    Brake_03ms2_1000km          INTEGER,
    Brake_04ms2_1000km          INTEGER,
    Brake_05ms2_1000km          INTEGER,
    Brake_06ms2_1000km          INTEGER,
    Brake_07ms2_1000km          INTEGER,
    LeftTurn_Low_1000km         INTEGER,
    LeftTurn_Med_1000km         INTEGER,
    LeftTurn_High_1000km        INTEGER,
    RightTurn_Low_1000km        INTEGER,
    RightTurn_Med_1000km        INTEGER,
    RightTurn_High_1000km       INTEGER,
    AMT_Claim                   REAL,
    NB_Claim                    INTEGER
);
