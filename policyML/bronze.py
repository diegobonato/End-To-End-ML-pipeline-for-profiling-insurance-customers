"""
This script loads data into the bronze layer of the data warehouse.
It connects to a PostgreSQL database and truncates the existing table before loading new data from the CSV file.

"""

import psycopg2

conn = psycopg2.connect(
    dbname="datawarehouse", user="postgres", password="postgres", host="localhost", port="5432"
)

with conn.cursor() as cur:
    cur.execute("TRUNCATE TABLE bronze.insurance;")

    with open("../data/raw/historic_dataset.csv", "r") as f:
        cur.copy_expert(
            """
            COPY bronze."insurance" (
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
            FROM STDIN WITH CSV HEADER
        """,
            f,
        )
    conn.commit()

print("Data loaded successfully via psycopg2.")


# check if the data was loaded correctly with psycopg2
with conn.cursor() as cur:
    cur.execute("SELECT COUNT(*) FROM bronze.insurance;")
    count = cur.fetchone()[0]
    assert count == 25000
