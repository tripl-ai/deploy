# aws-fargate-single

This deployment helps you to spin up a long-running single node container via Fargate in AWS ECS. ARC Jupyter Notebook fits in the use case here. 

### The terraform module creates 

```
- a VPC and networkings in the VPC. NOTE: CIDR is hardcoded. please change it based on your need  (network.tf)
- an Application Load Balancer (ALB) and a target group for port 8888,  4040 (alb.tf)
- an ECS service and a task definition (ecs.tf)
- a json file contains your docker run content (** templates/ecs/arc_app.json.tpl ** )

```

### Steps to run

0. Create a base infrastructure, including a terraform remote state bucket in s3.
- `cd base`
- `terraform init`
- `terraform apply`
- `cd ..`

1. Manual changes
- check/update s3 backend key, based on the output of the base infrastrcuture (provider.tf)
- update ECR docker images: app_image (vars.tf)
- manually create entries for AWS Access Key and AWS Secret Key in AWS Secrets Manager
- update secret ARNs accordingly (run.sh)
- don't want to setup the secrets? removed the parameters (run.sh, ecs.tf, templates/ecs/arc_app.json.tpl)

2. `terraform init`
3. `./run.sh` 


