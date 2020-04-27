output "lambda_function_name" {
  value = "${aws_lambda_function.lambda_function.function_name}"
}

output "lambda_role_name" {
  value = "${aws_iam_role.lambda_role.name}"
}
