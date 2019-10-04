# alb.tf

resource "aws_alb" "main" {
  name            = "arcjupyter-demo"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.lb.id]
}

resource "aws_alb_target_group" "web" {
  name        = "jupyter-target-group"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "5"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "302"
    timeout             = "120"
    path                = var.health_check_path
    unhealthy_threshold = "10"
  }
}


# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "web" {
  load_balancer_arn = aws_alb.main.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.web.id
    type             = "forward"
  }
}

