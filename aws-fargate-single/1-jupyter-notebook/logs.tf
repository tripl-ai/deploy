# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "arcdemo_log_group" {
  name              = "/ecs/${var.container_name}"
  retention_in_days = 30

  tags = {
    Name = "arcdemo-log-group"
  }
}

resource "aws_cloudwatch_log_group" "arc_etl_log_group" {
  name              = "/ecs/${var.arc_container_name}"
  retention_in_days = 30

  tags = {
    Name = "arcdemo-log-group"
  }
}
