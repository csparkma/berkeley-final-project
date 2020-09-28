# -*- coding: utf-8 -*-
"""Database_test

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1KFzTU3scUwZ1nOBzadp0_Qnhq0Yj7Gje
"""

import google.auth
from google.cloud import bigquery
from google.cloud.bigquery import storage

# Explicitly create a credentials object. This allows you to use the same
# credentials for both the BigQuery and BigQuery Storage clients, avoiding
# unnecessary API calls to fetch duplicate authentication tokens.
credentials, your_project_id = google.auth.default(
    scopes=["https://www.googleapis.com/auth/cloud-platform"]
)

# Make clients.
bqclient = bigquery.Client(credentials=credentials, project=your_project_id,)
bqstorageclient = storage.BigQueryReadClient(credentials=credentials)