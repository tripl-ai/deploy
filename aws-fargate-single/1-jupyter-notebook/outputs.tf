# outputs.tf

output "NOTEBOOK_URL" {
  value = "${aws_lb.alb.dns_name}:${var.app_port}"
}
