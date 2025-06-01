import pytest
import psycopg2


def test_connection():

    try:
        conn = psycopg2.connect(
            dbname="datawarehouse", user="postgres", password="postgres", host="localhost", port="5432"
        )
        conn.close()
        assert True
    except Exception as e:
        assert False, f"Connection failed: {e}"
