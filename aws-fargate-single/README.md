# aws-fargate-single

This deployment helps you to spin up a long-running single node container via AWS Fargate in Amazon ECS. ARC Jupyter Notebook fits in the use case here. 

### The terraform module creates 

```
- VPC and networkings in the VPC. NOTE: CIDR is hardcoded. please change it based on your need  (network.tf)
- Application Load Balancer (alb.tf)
- ECS service  (ecs.tf)
- Two ECS task definitions containing docker run commands (** templates/ecs/arc_app_iam.json.tpl & arc_etl_iam.json.tpl ** )

```

### Steps to run

1. `cd aws-fargate-single`

2. Manual change
- update ecs_s3_bucket name to your own in vars.tf 

```
skip the following steps if pulling docker images from a public docker hub 

- update ECR docker image: app_image & arc_image (vars.tf)
- Have to leverage AWS Secret Manager? checkout the example in templates/ecs/arc_app.json.tpl

```

3. `terraform init`

4. `./run.sh` 


