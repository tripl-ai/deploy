variable "aws_region" {
  description = "The region where to deploy this code (e.g. us-east-1)."
  default     = "ap-southeast-2"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "[YOUR_ACCOUNT_ID].dkr.ecr.ap-southeast-2.amazonaws.com/arc-jupyter:athena_scala_2.12"
}

variable "container_name" {
  description = "Docker Container name in ECS cluster"
  default     = "arc-jupyter"
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

variable "health_check_path" {
  default = "/"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "access_secret_arn" {
  description = "secret manager Arn for s3 access secret"
  default     = "blahblah"
}

variable "access_key_arn" {
  description = "secret manager Arn for s3 access key"
  default     = "blahblah"
}

variable "ecs_s3_bucket" {
  description = "s3 bucket name used by the ecs task"
  default     = "testtestmelody"
}

variable "arc_image" {
  description = "Docker image to run ARC ETL as an ECS task"
  default     = "[YOUR_ACCOUNT_ID].dkr.ecr.ap-southeast-2.amazonaws.com/arc:athena_scala_2.12"
}

variable "arc_container_name" {
  description = "Docker Container name for ARC ETL"
  default     = "arc-etl"
}


# variable "kms_arn" {
#   description = "s3 KMS arn"
#   default     = ""
# }
