# ecs.tf

resource "aws_ecs_cluster" "main" {
  name               = "arc-cluster"
  capacity_providers = ["FARGATE_SPOT", "FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 50
  }

  tags = {
    Name = "arcdemo_ecs"
  }
}

# -----------------------------------------------------
# Create ARC Jupyter task definition
# -----------------------------------------------------
data "template_file" "arc_jupyter" {
  template = file("./templates/ecs/arc_app.json.tpl")

  vars = {
    container_name    = var.container_name
    app_image         = var.app_image
    app_port          = var.app_port
    fargate_cpu       = var.fargate_cpu
    fargate_memory    = var.fargate_memory
    aws_region        = var.aws_region
    ecs_s3_bucket     = var.ecs_s3_bucket
    access_key_arn    = aws_secretsmanager_secret.accesskey.id
    access_secret_arn = aws_secretsmanager_secret.secret.id
  }
}

resource "aws_ecs_task_definition" "jupyter" {
  family                   = "${var.container_name}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.s3_ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.arc_jupyter.rendered
}


# -----------------------------------------------------
# Create ARC task definition
# -----------------------------------------------------
data "template_file" "arc_etl" {
  template = file("./templates/ecs/arc_etl.json.tpl")

  vars = {
    arc_container_name = var.arc_container_name
    arc_image          = var.arc_image
    fargate_cpu        = var.fargate_cpu
    fargate_memory     = var.fargate_memory
    aws_region         = var.aws_region
    ecs_s3_bucket      = var.ecs_s3_bucket
    access_key_arn     = aws_secretsmanager_secret.accesskey.id
    access_secret_arn  = aws_secretsmanager_secret.secret.id
  }
}

resource "aws_ecs_task_definition" "arc" {
  family                   = "${var.arc_container_name}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.s3_ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.arc_etl.rendered
}



resource "aws_ecs_service" "main" {
  name            = var.container_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.jupyter.arn
  desired_count   = var.app_count

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.web.id
    container_name   = var.container_name
    container_port   = var.app_port
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.spark.id
    container_name   = var.container_name
    container_port   = 4040
  }
  depends_on = [aws_alb_listener.web, aws_alb_listener.spark, aws_iam_role_policy_attachment.ecs_task_execution_role]
}
