import pytest
import psycopg2
from policyML.bronze.bronze import get_db_connection, load_bronze_data


def test_connection():

    try:
        conn = get_db_connection()
        conn.close()
        assert True
    except Exception as e:
        assert False, f"Connection failed: {e}"


def test_load_bronze_data():
    try:
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute(open("../policyML/medallion_datawarehouse.sql", "r").read())
            cur.execute(open("../policyML/bronze/bronze_create_table.sql", "r").read())

        load_bronze_data(conn, csv_path="../data/raw/historic_dataset.csv")
        conn.close()
        assert True
    except Exception as e:
        assert False, f"Data loading failed: {e}"

def test_data_integrity():
    try:
        conn = get_db_connection()
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM bronze.insurance;")
            count = cur.fetchone()[0]
            assert count == 25000, f"Expected 25000 rows, found {count}."
        conn.close()
    except Exception as e:
        assert False, f"Data integrity check failed: {e}"