#!/bin/bash
# terraform arguments
DESTROY_AFTER=$(($(date +%s) + 3600))


# function finish {
#   terraform destroy -auto-approve
# }
# trap finish EXIT
terraform apply -auto-approve \
-var="fargate_memory=20480" \
-var="fargate_cpu=4096"
