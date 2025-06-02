"""
This script loads data into the silver layer of the data warehouse.
It connects to a PostgreSQL database and truncates the existing table before loading new data from the bronze table
and performing the mapping of categorical variables.

"""

from pathlib import Path

from policyML.bronze.bronze import get_db_connection

path = Path(__file__).parents[2]  # set path to the root of the project


def create_silver_insurance_table(conn):
    """
    Drops the 'silver.insurance' table if it exists and creates it with the specified schema.

    Args:
        conn: A psycopg2 database connection object.

    Returns:
        None
    """

    with conn.cursor() as cur:
        cur.execute(open(path / "policyML/silver/silver_create_table.sql", "r").read())

    conn.commit()
    print("Table 'silver.insurance' created successfully.")


def main():
    conn = get_db_connection()
    create_silver_insurance_table(conn)

    with conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM silver.insurance;")
        count = cur.fetchone()[0]
        conn.close()
        assert count == 25_000


if __name__ == "__main__":
    main()
    print("Silver layer loaded successfully.")
