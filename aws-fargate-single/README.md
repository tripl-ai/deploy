# aws-fargate-single

This deployment helps you to spin up a long-running single node container via Fargate in AWS ECS. ARC Jupyter Notebook fits in the use case here. 

### The terraform module creates 

```
- a VPC and networkings in the VPC. NOTE: CIDR is hardcoded. please change it based on your need  (network.tf)
- an Application Load Balancer (ALB) and a target group for port 8888. Not listening to 4040 at this stage. Feel free to add it. (alb.tf)
- an ECS service and a task definition (ecs.tf)
- a json file contains your docker run content (** templates/ecs/arc_app.json.tpl ** )


```

### Steps to run

1. Manual change in var.tf
- update parameters: app_image & az_count 
- create s3 access key secrets in your secret manager
- if you don't want to setup the s3 secret at the deployment stage,  removed the parameters from var.tf, ecs.tf, arc_app.json.tpl

2. `terraform init`
3. `run.sh`
