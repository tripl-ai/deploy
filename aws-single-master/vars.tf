variable "aws_region" {
  description = "The region where to deploy this code (e.g. us-east-1)."
  default = "ap-southeast-2"
}

variable "driver_instance_type" {
  description = "The type of instance to start (e.g. t3.micro)."
  default = "t3.nano"
}

variable "key_name" {
  description = "The name of the keypair created in EC2."
}

variable "private_key" {
  description = "The full local path of the private_key file (.pem)."
}

variable "destroy_after" {
  description = "A unix timestamp after which this instance should be destroyed if still running."
}

variable "docker_tag" {
  description = "The tag of the Arc docker image."
  default = "arc_2.0.0_spark_2.4.3_scala_2.11_hadoop_2.9.2_1.1.0"
}

variable "additional_docker_run_commands" {
  description = "Job specific docker run commands like -e \"ETL_CONF_S3A_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE\"."
  default = ""
}

variable "config_uri" {
  description = "The URI of the job file."
}