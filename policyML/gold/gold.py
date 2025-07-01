"""
This script loads data into the gold layer of the data warehouse.
It connects to a PostgreSQL database and truncates the existing table before loading new data from the silver table
and creates the views for the gold layer.

"""

import logging
from pathlib import Path

from policyML.bronze.bronze import get_db_connection

path = Path(__file__).parents[2]  # set path to the root of the project
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def create_gold_insurance_tables(conn):
    """
    Drops the gold aggregation tables if they exist and create them with the specified schema and queries.


    Args:
        conn: A psycopg2 database connection object.

    Returns:
        None
    """

    with conn.cursor() as cur:
        cur.execute(open(path / "policyML/gold/gold_create_table.sql", "r").read())

    conn.commit()
    logger.info("Gold insurance tables created successfully.")


def main():
    conn = get_db_connection()
    create_gold_insurance_tables(conn)

    with conn.cursor() as cur:
        # print all the tables in the gold schema
        cur.execute(
            "SELECT table_name FROM information_schema.tables WHERE table_schema = 'gold';"
        )
        tables = cur.fetchall()
        for table in tables:
            cur.execute(f"SELECT COUNT(*) FROM gold.{table[0]};")
            count = cur.fetchone()[0]
            logger.info(f"Table {table[0]} has {count} rows.")
        conn.close()


if __name__ == "__main__":
    main()
