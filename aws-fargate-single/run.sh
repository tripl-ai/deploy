#!/bin/bash

S3_SECRET_ARN=arn:aws:secretsmanager:[AWS_REGION]:[AWS_ACCOUNT_ID]:secret:xxx
S3_KEY_ARN=arn:aws:secretsmanager:[AWS_REGION]:[AWS_ACCOUNT_ID]:secret:xxx


# start remote machines and job
terraform apply -auto-approve \
-var="fargate_memory=20480" \
-var="fargate_cpu=4096" \
-var="access_secret_arn=${S3_SECRET_ARN}" \
-var="access_key_arn=${S3_KEY_ARN}"


