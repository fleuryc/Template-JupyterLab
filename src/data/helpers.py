"""Helper functions, not project specific."""

import io
import logging
import os
import zipfile

import requests


def download_extract_zip(
    zip_file_url: str,
    files_names: tuple[str],
    target_path: str,
) -> None:
    """Download Zip from url and extract content files to local path.

    - Check if content files already exist.
        - If they all exist, return.
        - If not, download zip file and extract content files.

    Args:
        zip_file_url: Url of zip file to download.
        files_names: List of file names to extract from zip.
        target_path: Path to extract zip contents to.

    Returns:
        None
    """
    # We must NOT download and extract zip file by default.
    must_download: bool = False

    for file in files_names:
        # Check if content files exist
        file_path = os.path.join(target_path, file)
        if not os.path.exists(file_path):
            # If at least one file does not exist, we must download zip file
            must_download = True
            break

    # If all files already exist, return
    if not must_download:
        logging.info(f"All files already exist in {target_path}")
        return

    # Download zip file
    r = requests.get(zip_file_url)
    if r.status_code != 200:
        logging.error(f"Error downloading {zip_file_url}")
        raise ValueError(f"Failed to download {zip_file_url}")

    # Check if zip file is OK
    z = zipfile.ZipFile(io.BytesIO(r.content))
    if z.testzip() is not None:
        logging.error(f"Error extracting {zip_file_url}")
        raise ValueError(f"Failed to extract {zip_file_url}")

    # Check if content path exists
    if not os.path.exists(target_path):
        logging.info(f"Creating {target_path}")
        os.makedirs(target_path)

    # Extract files from zip
    logging.info(f"Extracting {zip_file_url} to {target_path}")
    z.extractall(target_path)
    logging.info(f"Extracted {zip_file_url} to {target_path}")
