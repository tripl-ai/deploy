# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "arc_log_group" {
  name              = "/ecs/${var.container_name}"
  retention_in_days = 30

  tags = {
    Name = "arc-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "arc_log_stream" {
  name           = "arc-log-stream"
  log_group_name = aws_cloudwatch_log_group.arc_log_group.name
}
