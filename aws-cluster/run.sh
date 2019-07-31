#!/bin/bash
# terraform arguments
KEY_NAME=arc
DESTROY_AFTER=$(($(date +%s) + 3600))
PRIVATE_KEY=$(pwd)/arc.pem
WORKER_COUNT=1

# arc arguments
CONFIG_URI=file:///tmp/job/job.json

function finish {
  echo "ok"
  # stop remote machines regardless of outcome
  terraform destroy -auto-approve \
  -var="key_name=${KEY_NAME}" \
  -var="destroy_after=${DESTROY_AFTER}" \
  -var="private_key=${PRIVATE_KEY}" \
  -var="worker_count=${WORKER_COUNT}" \
  -var="config_uri=${CONFIG_URI}" 
}
trap finish EXIT
# start remote machines and job
terraform apply -auto-approve \
-var="key_name=${KEY_NAME}" \
-var="destroy_after=${DESTROY_AFTER}" \
-var="private_key=${PRIVATE_KEY}" \
-var="worker_count=${WORKER_COUNT}" \
-var="config_uri=${CONFIG_URI}"
