"""
This script loads data into the bronze layer of the data warehouse.
It connects to a PostgreSQL database and truncates the existing table before loading new data from the CSV file.

"""

import logging
from pathlib import Path

import psycopg2

path = Path(__file__).parents[2]  # set path to the root of the project
logger = logging.getLogger(__name__)


def get_db_connection(
    dbname="datawarehouse", user="postgres", password="postgres", host="localhost", port="5432"
):
    """
    Establishes and returns a connection to a PostgreSQL database.

    Args:
        dbname (str): Name of the database. Default is "datawarehouse".
        user (str): Username for authentication. Default is "postgres".
        password (str): Password for authentication. Default is "postgres".
        host (str): Database host address. Default is "localhost".
        port (str): Port number. Default is "5432".

    Returns:
        conn (psycopg2.extensions.connection): A connection object to the database.
    """
    conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host, port=port)
    return conn


def create_bronze_insurance_table(conn):
    """
    Drops the 'bronze.insurance' table if it exists and creates it with the specified schema.

    Args:
        conn: A psycopg2 database connection object.

    Returns:
        None
    """

    with conn.cursor() as cur:
        cur.execute(open(path / "policyML/bronze/bronze_create_table.sql", "r").read())

    conn.commit()
    logger.info("Bronze insurance table created successfully.")


def load_bronze_data(conn, csv_path=path / "data/raw/historic_dataset.csv"):
    """
    Truncates the bronze.insurance table and loads data from a CSV file into it.

    Args:
        conn: A psycopg2 database connection object.
        csv_path (str): Path to the CSV file to load. Default is the relative path to 'historic_dataset.csv'.

    Returns:
        None
    """
    with conn.cursor() as cur:
        cur.execute("TRUNCATE TABLE bronze.insurance;")

        with open(csv_path, "r") as f:
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

    logger.info("Bronze data loaded successfully into the bronze.insurance table.")


# check if the data was loaded correctly with psycopg2
def main():
    conn = get_db_connection()
    create_bronze_insurance_table(conn)
    load_bronze_data(conn)

    with conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM bronze.insurance;")
        count = cur.fetchone()[0]
        conn.close()
        assert count == 25_000


if __name__ == "__main__":
    main()
