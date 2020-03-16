# aws-fargate-single

This deployment helps you to spin up a long-running single node container via AWS Fargate in Amazon ECS. ARC Jupyter Notebook fits in the use case here. 

### The terraform module creates 

```
- a VPC and networkings in the VPC. NOTE: CIDR is hardcoded. please change it based on your need  (network.tf)
- an Application Load Balancer (ALB)  (alb.tf)
- an ECS service and two task definitions (ecs.tf)
- a json file contains your docker run content (** templates/ecs/arc_app_iam.json.tpl or arc_etl_iam.json.tpl ** )

```

### Steps to run

0. Manual change  ( skip the step if pulling docker images from a public docker hub )
- update ECR docker image : app_image & arc_image (vars.tf)
- Have to leverage AWS Secret Manager? checkout the example in templates/ecs/arc_app.json.tpl

1. `cd aws-fargate-single`
2. `terraform init`
3. `./run.sh` 


