data "aws_s3_bucket" "selected" {
  bucket = var.s3_bucket_name
}

data "aws_ecs_task_definition" "etl" {
  task_definition = "${var.ecs_container_name-task}"
}

data "aws_security_group" "selected" {
  filter {
    name   = "tag:Name"
    values = ["arc-ecs*"]
  }
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_security_group.selected.vpc_id

  filter {
    name   = "tag:Name"
    values = ["arcdemo_private*"]
  }
}


resource "aws_lambda_function" "lambda_function" {
  function_name    = "tf-s3-ecs-task"
  handler          = "index.handler"
  runtime          = "nodejs10.x"
  role             = aws_iam_role.lambda_role.arn
  filename         = var.lambda_source_package
  source_code_hash = filebase64sha256(var.lambda_source_package)

  timeout = 60
  vpc_config {
    subnet_ids         = data.aws_subnet_ids.selected.ids
    security_group_ids = [data.aws_security_group.selected.id]
  }


  environment {
    variables = {
      region         = var.region
      IS_STREAM      = var.is_stream
      CLUSTER_NAME   = var.ecs_cluster_name
      TASK_ID        = "${var.ecs_container_name}-task:${data.aws_ecs_task_definition.etl.revision}"
      subnet_ids     = join(",", data.aws_subnet_ids.selected.ids)
      etl_task_sg_id = data.aws_security_group.selected.id
      container_name = var.ecs_container_name

    }
  }

  depends_on = [aws_iam_role_policy_attachment.lamba_exec_role_eni, aws_iam_role_policy.ecs_lambda]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = data.aws_s3_bucket.selected.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_function.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.filterprefix
    filter_suffix       = var.filtersuffix
  }
}
