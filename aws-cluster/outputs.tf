output "public_dns" {
  value = "${aws_instance.arc_driver.public_dns}"
}

output "environment_id" {
  value = "${random_uuid.uuid.result}"
}