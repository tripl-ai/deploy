#!/bin/bash

S3_SECRET_ARN=arn:aws:secretsmanager:[YOUR_AWS_REGION]:[YOUR_ACCOUNT_ID]:secret:ETL_CONF_S3A_SECRET_KEY-xxx
S3_KEY_ARN=arn:aws:secretsmanager:[YOUR_AWS_REGION]:[YOUR_ACCOUNT_ID]:secret:ETL_CONF_S3A_ACCESS_KEY-xxx
# KMS_ARN=arn:aws:kms:ap-southeast-2:[ACCOUNT_ID]:key/xxxxx

# start remote machines and job
terraform apply -auto-approve \
-var="fargate_memory=20480" \
-var="fargate_cpu=4096" \
-var="access_secret_arn=${S3_SECRET_ARN}" \
-var="access_key_arn=${S3_KEY_ARN}"
# -var="kms_arn=${KMS_ARN}"


