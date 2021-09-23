"""Helper functions, not project specific."""

from typing import Union

import pandas as pd


def drop_impossible_values(
    dataframe: pd.DataFrame,
    constraints=dict[str, dict[str, Union[int, float]]],
) -> pd.DataFrame:
    """Drop values from a dataframe that have impossible or unlikely values.

    :param dataframe: The dataframe to be filtered.
    :param constraints: A dictionary of constraints to be applied.

    :return: The filtered dataframe.

    Example:
    constraints = {
        'age': {
            'min': 18,
            'max': 60
        }
    }
    """
    for col in dataframe.columns:
        if col in constraints:
            dataframe = dataframe[
                dataframe[col].between(constraints[col]["min"], constraints[col]["max"])
            ]
    return dataframe
