#!/bin/bash

s3_secret_arn=[Your secretsmanager arn]
s3_key_arn=[Your secretsmanager arn]

# start remote machines and job
terraform apply -auto-approve \
-var="fargate_memory=20480" \
-var="fargate_cpu=4096" \
-var="access_secret_arn=${s3_secret_arn}" \
-var="access_key_arn=${s3_key_arn}"


