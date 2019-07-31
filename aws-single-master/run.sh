#!/bin/bash
# terraform arguments
KEY_NAME=arc
DESTROY_AFTER=$(($(date +%s) + 3600))
PRIVATE_KEY=$(pwd)/arc.pem

# arc arguments
CONFIG_URI=file:///tmp/job/job.json

function finish {
  # stop remote machine regardless of outcome
  terraform destroy -auto-approve \
  -var="key_name=${KEY_NAME}" \
  -var="destroy_after=${DESTROY_AFTER}" \
  -var="private_key=${PRIVATE_KEY}" \
  -var="config_uri=${CONFIG_URI}"
}
trap finish EXIT
# start remote machine and job
terraform apply -auto-approve \
-var="key_name=${KEY_NAME}" \
-var="destroy_after=${DESTROY_AFTER}" \
-var="private_key=${PRIVATE_KEY}" \
-var="config_uri=${CONFIG_URI}"
