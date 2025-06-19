# End-To-End-ML-pipeline-for-profiling-insurance-customers

## Data Warehouse
This project implements a comprehensive ETL pipeline for profiling insurance customers. We designed and built a data warehouse using the Medallion architecture (Bronze, Silver, Gold layers) to ensure robust data ingestion, transformation, and analytics. The Medallion schema enables scalable, reliable, and maintainable data workflows, supporting the end-to-end ML lifecycle from raw data collection to advanced modeling and reporting.

The data warehouse is structured into three layers:
- The Bronze layer ingests raw data from CSV files, ensuring data integrity and traceability. 
- The Silver layer performs essential transformations, including data cleaning, feature engineering, and aggregation, to prepare the data for the ML models. 
- The Gold layer provides curated tables optimized for reporting and analysis, enabling stakeholders to derive insights from the data efficiently.

![alt text](docs/docs/figures/warehouse.png "Warehouse")


-------- 
## Project Organization

```
├── LICENSE            <- Open-source license 
├── Makefile           <- Makefile with convenience commands like `make data` or `make train`
├── README.md          <- The top-level README 
├── data
│   ├── processed      <- The final, canonical data sets for modeling.
│   └── raw            <- The original, immutable data dump.
│
├── docs               <- A mkdocs project; see www.mkdocs.org for details
│
├── models             <- Trained and serialized models, model predictions, or model summaries
│
├── notebooks          <- Jupyter notebooks. Naming convention is a number (for ordering),
│                         the creator's initials, and a short `-` delimited description, e.g.
│                         `1.0-jqp-initial-data-exploration`.
│
├── pyproject.toml     <- Project configuration file with package metadata for 
│                         policyML and configuration for tools like black
│
├── references         <- Data dictionaries, manuals, and all other explanatory materials.
│
├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
│   └── figures        <- Generated graphics and figures to be used in reporting
│
├── compose.yml      <- Docker Compose file for running the project in a containerized environment including postgres server
│
└── policyML   <- Source code for use in this project.
    │
    ├── bronze        <- Bronze layer for raw data ingestion
    │   ├── __init__.py
    │   ├── bronze.py  <- Bronze layer ETL script
    │   └── bronze_create_table.sql <- SQL script to create bronze layer table
    │
    ├── silver        <- Silver layer for data transformation
    │   ├── __init__.py
    │   ├── silver.py  <- Silver layer ETL script
    │   └── silver_create_table.sql <- SQL script to create silver layer table
    │
    ├── gold          <- Gold layer for reporting and analytics
    │   ├── __init__.py
    │   ├── gold.py    <- Gold layer ETL script
    │   └── gold_create_table.sql <- SQL script to create gold layer table
    │
    ...
│
└── tests              <- Unit tests for the project
    ├── __init__.py
    ├── test_data.py  <- Unit tests
```

--------