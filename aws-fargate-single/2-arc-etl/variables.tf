variable "region" {
  description = "The AWS region we want this bucket to live in."
  default     = "ap-southeast-2"
}

variable "filterprefix" {
  default = "job"
}

variable "filtersuffix" {
  default = "ipynb"
}

variable "lambda_source_package" {
  default = "lambda_func.js.zip"
}

variable "s3_bucket_name" {
  description = "The S3 bucket name to have an event trigger setup"
  default     = "arcdemo2020"
}

variable "ecs_cluster_name" {
  default = "arc-cluster"
}

variable "ecs_container_name" {
  default = "arc-etl"
}

variable "is_stream" {
  description = "true or false to determin if the ECS task going to be a streaming process or batch process"
  default     = "false"
}

