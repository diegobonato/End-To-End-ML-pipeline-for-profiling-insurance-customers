"""
Raw data preparations for the policyML project.

Phase 1: Splitting the dataset into historic and new datasets (used for training).
Phase 2: Splitting the new dataset into monthly datasets (used for inference).
"""

import logging
from pathlib import Path

import pandas as pd
from sklearn.model_selection import train_test_split

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def split_dataset_into_historic_and_new(data_dir: Path = Path("../data/raw")) -> None:
    """
    Splits a training dataset into two disjoint datasets: historic and new.

    The function loads a CSV file named 'trainset.csv' from the specified directory,
    performs a 50/50 random split, verifies disjointness, and saves the resulting
    subsets as 'historic_dataset.csv' and 'new_dataset.csv'.

    Parameters:
        data_dir (Path): Directory where 'trainset.csv' is located and where the
                         output files will be saved.
    """
    input_path = data_dir / "source" / "trainset.csv"
    historic_path = data_dir / "historic_dataset.csv"
    new_path = data_dir / "new_dataset.csv"

    logger.info(f"Loading dataset from: {input_path}")
    df = pd.read_csv(input_path)

    historic_dataset, new_dataset = train_test_split(df, test_size=0.5, random_state=42)

    if not historic_dataset.merge(new_dataset).empty:
        raise ValueError("Datasets are not disjoint")

    logger.info(f"Saving historic dataset to: {historic_path}")
    historic_dataset.to_csv(historic_path, index=False)

    logger.info(f"Saving new dataset to: {new_path}")
    new_dataset.to_csv(new_path, index=False)


## TODO: Implement Phase 2


def monthly_split_new_dataset(data_dir: Path = Path("../data/raw")) -> None:
    """
    Splits the new dataset into monthly datasets for inference.

    This function is a placeholder for future implementation.
    It will take the 'new_dataset.csv' and split it into monthly datasets.
    """
    logger.info("Monthly split of new dataset is not yet implemented.")
    # Implementation will go here in the future
    pass
