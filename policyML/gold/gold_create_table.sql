CREATE SCHEMA IF NOT EXISTS gold;

DROP TABLE IF EXISTS gold.claims_by_region;

-- Create a table that aggregates claims data by region
CREATE TABLE gold.claims_by_region AS
SELECT
    Insured_RegionID,

    COUNT(ID) AS policy_count,
    SUM(NB_Claim) AS total_claims,
    AVG(NB_Claim::FLOAT) AS avg_claims,
    SUM(AMT_Claim) AS total_claim_amount,
    AVG(AMT_Claim::FLOAT) AS avg_claim_amount

FROM silver.insurance
GROUP BY Insured_RegionID;

-- Create a table that aggregates claims by car usage
DROP TABLE IF EXISTS gold.claims_by_car_usage;

CREATE TABLE gold.claims_by_car_usage AS
SELECT
    Car_Use,
    
    COUNT(ID) AS policy_count,
    SUM(NB_Claim) AS total_claims,
    AVG(NB_Claim::FLOAT) AS avg_claims,
    SUM(AMT_Claim) AS total_claim_amount,
    AVG(AMT_Claim::FLOAT) AS avg_claim_amount
FROM silver.insurance
GROUP BY Car_Use;

-- Create a table that aggregates claims by age group
DROP TABLE IF EXISTS gold.claims_by_age_group;
CREATE TABLE gold.claims_by_age_group AS
SELECT
    CASE
        WHEN Insured_Age < 25 THEN 'Under 25'
        WHEN Insured_Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Insured_Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Insured_Age BETWEEN 45 AND 54 THEN '45-54'
        WHEN Insured_Age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65 and over'
    END AS age_group,
    
    COUNT(ID) AS policy_count,
    SUM(NB_Claim) AS total_claims,
    AVG(NB_Claim::FLOAT) AS avg_claims,
    SUM(AMT_Claim) AS total_claim_amount,
    AVG(AMT_Claim::FLOAT) AS avg_claim_amount
FROM silver.insurance
GROUP BY age_group;

-- Create a table that aggregates claims by age and hard events
DROP TABLE IF EXISTS gold.behavior_by_age;

CREATE TABLE gold.behavior_by_age AS
SELECT
    -- Age group binning
    CASE
        WHEN Insured_Age < 25 THEN '<25'
        WHEN Insured_Age >= 25 AND Insured_Age < 35 THEN '25-34'
        WHEN Insured_Age >= 35 AND Insured_Age < 45 THEN '35-44'
        WHEN Insured_Age >= 45 AND Insured_Age < 55 THEN '45-54'
        WHEN Insured_Age >= 55 AND Insured_Age < 65 THEN '55-64'
        WHEN Insured_Age >= 65 THEN '65+'
        ELSE 'Unknown'
    END AS agegroup,

    -- Average hard braking and acceleration events
    AVG(Brake_06ms2_1000km + Brake_07ms2_1000km) AS avg_hard_brakes,
    AVG(Accel_06ms2_1000km + Accel_07ms2_1000km) AS avg_hard_accelerations

FROM silver.insurance
GROUP BY agegroup
ORDER BY agegroup;


-- create a table that aggregates claims by car age and hard events
DROP TABLE IF EXISTS gold.behavior_by_car_age;

CREATE TABLE gold.behavior_by_car_age AS
SELECT
    -- Car age group binning
    CASE
        WHEN Car_Age >= 0 AND Car_Age < 6 THEN '0-5'
        WHEN Car_Age >= 6 AND Car_Age < 11 THEN '6-10'
        WHEN Car_Age >= 11 AND Car_Age < 16 THEN '11-15'
        WHEN Car_Age >= 16 AND Car_Age < 21 THEN '16-20'
        ELSE 'Unknown'
    END AS car_age_group,

    -- Average hard braking and acceleration events
    AVG(Brake_06ms2_1000km + Brake_07ms2_1000km) AS avg_hard_brakes,
    AVG(Accel_06ms2_1000km + Accel_07ms2_1000km) AS avg_hard_accelerations

FROM silver.insurance
GROUP BY car_age_group
ORDER BY car_age_group;

-- risk assessment and categorization
-- Step 1: Compute Risk Category


DROP MATERIALIZED VIEW IF EXISTS gold.risk_scored_policies;

CREATE MATERIALIZED VIEW gold.risk_scored_policies AS
WITH base_data AS (
    SELECT
        *,
        Brake_06ms2_1000km + Brake_07ms2_1000km AS hard_brakes,
        Accel_06ms2_1000km + Accel_07ms2_1000km AS hard_accelerations
    FROM silver.insurance
),
aggressive_calc AS (
    SELECT *,
        (hard_brakes + hard_accelerations) AS aggressive
    FROM base_data
),
risk_calc AS (
    SELECT *,
        NB_Claim * 5
        + aggressive::FLOAT / 10
        + (900 - Insured_CreditScore)::FLOAT / 50 AS risk_score
    FROM aggressive_calc
),
median_score AS (
    SELECT
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY risk_score) AS median_risk
    FROM risk_calc
),
labeled AS (
    SELECT
        r.*,
        m.median_risk,
        CASE
            WHEN r.risk_score >= m.median_risk THEN 'High'
            ELSE 'Low'
        END AS risk_category
    FROM risk_calc r
    CROSS JOIN median_score m
)
SELECT * FROM labeled;


DROP TABLE IF EXISTS gold.risk_by_status;

CREATE TABLE gold.risk_by_status AS
SELECT
    Insured_Status,
    COUNT(*) FILTER (WHERE risk_category = 'High') AS high_risk,
    COUNT(*) FILTER (WHERE risk_category = 'Low') AS low_risk
FROM gold.risk_scored_policies
GROUP BY Insured_Status;

DROP TABLE IF EXISTS gold.risk_by_sex;

CREATE TABLE gold.risk_by_sex AS
SELECT
    insured_sex,
    COUNT(*) FILTER (WHERE risk_category = 'High') AS high_risk,
    COUNT(*) FILTER (WHERE risk_category = 'Low') AS low_risk
FROM gold.risk_scored_policies
GROUP BY insured_sex;

DROP TABLE IF EXISTS gold.risk_by_region;

CREATE TABLE gold.risk_by_region AS
SELECT
    insured_regionid,
    COUNT(*) FILTER (WHERE risk_category = 'High') AS high_risk,
    COUNT(*) FILTER (WHERE risk_category = 'Low') AS low_risk
FROM gold.risk_scored_policies
GROUP BY insured_regionid;