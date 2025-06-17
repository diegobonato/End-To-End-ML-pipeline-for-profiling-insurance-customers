import pytest
import psycopg2
from policyML.bronze.bronze import (
    get_db_connection,
    load_bronze_data,
    create_bronze_insurance_table,
)
from policyML.silver.silver import create_silver_insurance_table
from policyML.gold.gold import create_gold_insurance_tables


def test_connection():
    try:
        conn = get_db_connection()
        conn.close()
        assert True
    except Exception as e:
        assert False, f"Connection failed: {e}"


def test_load_bronze_data():
    conn = get_db_connection()
    create_bronze_insurance_table(conn)
    try:
        load_bronze_data(conn)
        conn.close()
        assert True
    except Exception as e:
        conn.close()
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


def test_silver_layer():
    try:
        conn = get_db_connection()
        create_silver_insurance_table(conn)
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM silver.insurance;")
            count = cur.fetchone()[0]
            assert count == 25000, f"Expected 25000 rows in silver layer, found {count}."
        conn.close()
    except Exception as e:
        assert False, f"Silver layer test failed: {e}"


def test_gold_layer():
    try:

        conn = get_db_connection()
        create_gold_insurance_tables(conn)
        with conn.cursor() as cur:
            cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'gold';")
            tables = cur.fetchall()
            assert len(tables) > 0, "No tables found in the gold schema."
            for table in tables:
                cur.execute(f"SELECT COUNT(*) FROM gold.{table[0]};")
                count = cur.fetchone()[0]
                assert count > 0, f"Table {table[0]} is empty."
        conn.close()
    except Exception as e:
        assert False, f"Gold layer test failed: {e}"
