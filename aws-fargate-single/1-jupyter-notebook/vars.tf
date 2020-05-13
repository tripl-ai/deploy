variable "aws_region" {
  description = "The region where to deploy this code (e.g. us-east-1)."
  default     = "ap-southeast-2"
}

variable "app_image" {
  description = "Docker image to run arc jupyter notebook as an ECS service"
  default     = "triplai/arc-jupyter"
  # default     = "[YOUR_ACCOUNT_ID].dkr.ecr.ap-southeast-2.amazonaws.com/arc-jupyter:athena_scala_2.12"
}

variable "arc_image" {
  description = "Docker image to run ARC ETL as an ECS task"
  default     = "triplai/arc"
  # default     = "[YOUR_ACCOUNT_ID].dkr.ecr.ap-southeast-2.amazonaws.com/arc:athena_scala_2.12"
}


variable "container_name" {
  description = "Docker Container name in ECS cluster"
  default     = "arc-jupyter"
}

variable "arc_container_name" {
  description = "Docker Container name for ARC ETL"
  default     = "arc-etl"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8888
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = "1"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

# variable "ecs_auto_scale_role_name" {
#   description = "ECS auto scale role Name"
#   default     = "myEcsAutoScaleRole"
# }

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "ecs_s3_bucket" {
  description = "s3 bucket name used to store ARC configuration files"
  default     = "arcdemo2020"
}

