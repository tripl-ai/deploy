resource "null_resource" "remove_and_upload_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 sync ../appcode/ s3://${var.ecs_s3_bucket}/appcode/"
  }
}

