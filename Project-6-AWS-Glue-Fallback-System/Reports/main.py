
import os
import boto3
import pandas as pd
from sqlalchemy import create_engine
import logging

#Configuration 
S3_BUCKET = 'project6-data-bucket-shyam'
S3_KEY = 'students.csv'
RDS_HOST = 'student-database.cq5uge448u0v.us-east-1.rds.amazonaws.com'
RDS_USER = 'admin'
RDS_PASSWORD = 'Shyam22062003'
RDS_DB_NAME = 'studentdb'
GLUE_DB_NAME = 'student_data_fallback'
GLUE_TABLE_NAME = 'students_fallback'
AWS_REGION = 'us-east-1'

# Setup basic logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def main():
    """Main ETL function to process data from S3 to RDS with a Glue fallback."""
    logging.info("Starting ETL process...")
    
    # 1. Extract data from S3
    try:
        s3_client = boto3.client('s3')
        response = s3_client.get_object(Bucket=S3_BUCKET, Key=S3_KEY)
        df = pd.read_csv(response.get("Body"))
        logging.info(f"Successfully extracted {len(df)} rows from S3.")
    except Exception as e:
        logging.error(f"FATAL: Could not extract data from S3. Error: {e}")
        return

    # 2. Attempt to load data into RDS (Primary Target)
    try:
        logging.info("Attempting to load data into RDS...")
        connection_str = f"mysql+pymysql://{RDS_USER}:{RDS_PASSWORD}@{RDS_HOST}/{RDS_DB_NAME}"
        engine = create_engine(connection_str, connect_args={'connect_timeout': 5})
        
        with engine.connect() as connection:
            df.to_sql('students', con=connection, if_exists='append', index=False)
            logging.info("SUCCESS: Data loaded into RDS successfully.")
            
    except Exception as rds_error:
        logging.warning(f"RDS Load Failed. Reason: {rds_error}")
        logging.info("Executing fallback: Registering table in AWS Glue Data Catalog.")
        
        # 3. Fallback to AWS Glue
        try:
            glue_client = boto3.client('glue', region_name=AWS_REGION)
            
            type_mapping = {'object': 'string', 'int64': 'int', 'float64': 'double'}
            columns = [{'Name': col, 'Type': type_mapping.get(str(dtype), 'string')} for col, dtype in df.dtypes.items()]

            glue_client.create_table(
                DatabaseName=GLUE_DB_NAME,
                TableInput={
                    'Name': GLUE_TABLE_NAME,
                    'Description': 'Fallback table for student data.',
                    'StorageDescriptor': {
                        'Columns': columns,
                        'Location': f's3://{S3_BUCKET}/',
                        'InputFormat': 'org.apache.hadoop.mapred.TextInputFormat',
                        'SerdeInfo': { 'SerializationLibrary': 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe', 'Parameters': {'field.delim': ','} }
                    },
                    'TableType': 'EXTERNAL_TABLE'
                }
            )
            logging.info(f"SUCCESS (Fallback): Created Glue table '{GLUE_TABLE_NAME}'.")
            
        except Exception as glue_error:
            logging.error(f"FATAL: Fallback to Glue also failed. Error: {glue_error}")

if __name__ == "__main__":
    main()