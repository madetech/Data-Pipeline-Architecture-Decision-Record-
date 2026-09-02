"""
data_ingestion.py

Handles the ingestion of raw data from various sources.
Outputs from this module represent the bronze layer when using
a Medallion Architecture approach.
"""


class DataIngestor:
    """
    Responsible for extracting raw data from external sources
    such as S3 buckets and source databases.
    """

    def __init__(self, **kwargs):
        """
        Initializes the DataIngestor with any required configuration.

        Args:
            **kwargs: Configuration parameters (e.g., credentials, region).
        """
        pass

    def extract_from_s3(self, bucket_name, file_key, **kwargs):
        """
        Extracts raw data from an S3 bucket.

        Args:
            bucket_name (str): Name of the S3 bucket.
            file_key (str): Path/key to the file within the bucket.
            **kwargs: Additional extraction parameters.

        Returns:
            DataFrame: Raw extracted data representing the bronze layer.
        """
        pass

    def extract_from_source_db(self, connection, query, **kwargs):
        """
        Extracts raw data from a source database.

        Args:
            connection: Active database connection object.
            query (str): SQL query used to extract data.
            **kwargs: Additional extraction parameters.

        Returns:
            DataFrame: Raw extracted data representing the bronze layer.
        """
        pass