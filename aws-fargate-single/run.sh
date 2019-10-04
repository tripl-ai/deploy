#!/bin/bash

s3_secret_arn=arn:aws:secretsmanager:ap-southeast-2:xx:secret:ETL_CONF_S3A_SECRET_KEY-xxxx
s3_key_arn=arn:aws:secretsmanager:ap-southeast-2:xx:secret:ETL_CONF_S3A_ACCESS_KEY-xxxxxx

# start remote machines and job
terraform apply -auto-approve \
-var="fargate_memory=20480" \
-var="fargate_cpu=4096" \
-var="access_secret_arn=${s3_secret_arn}" \
-var="access_key_arn=${s3_key_arn}"


