resource "aws_secretsmanager_secret" "secret" {
  name = "ATHENA_PWD"
}

resource "aws_secretsmanager_secret" "accesskey" {
  name = "ATHENA_UID"
}


resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = "UPDATE_ME_TO_SECRET_KEY"
}

resource "aws_secretsmanager_secret_version" "accesskey" {
  secret_id     = aws_secretsmanager_secret.accesskey.id
  secret_string = "UPDATE_ME_TO_ACCESS_KEY"
}
