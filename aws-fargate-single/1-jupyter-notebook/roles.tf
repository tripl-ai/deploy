# ECS task execution role data
data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


# ECS task execution role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json

  tags = {
    Name = "arcdemo-execrole"
  }
}



## Allow to retrive AWS access key from Secrets Manager
# -------------------------------- BEGIN -------------------------------------------
data "aws_iam_policy_document" "ecs_secret" {
  statement {
    sid       = ""
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [aws_secretsmanager_secret.accesskey.id, aws_secretsmanager_secret.secret.id]
  }
}

resource "aws_iam_role_policy" "ecs_secret" {
  name   = "ecs_secret_policy"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.ecs_secret.json
}
# -------------------------------- END -------------------------------------------

# ## If source s3 bucket is encrypted, uncomment the block and update the alias with your own
# # -------------------------------- BEGIN -------------------------------------------
# data "aws_kms_key" "extract_key" {
#   key_id = "alias/${var.ecs_s3_bucket}-kms-key"
# }
# # -------------------------------- END -------------------------------------------



# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS task role
#need the role for ARC IAM authentication
data "aws_iam_policy_document" "s3_ecs_task_role" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::${var.ecs_s3_bucket}", "arn:aws:s3:::nyc-tlc"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${var.ecs_s3_bucket}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = ["arn:aws:s3:::nyc-tlc/*"]
  }


  # ## Uncomment if your source s3 bucket is encrypted.
  # # -------------------------------- BEGIN -------------------------------------------
  # statement {
  #   effect = "Allow"
  #   actions = [
  #     "kms:Decrypt"
  #   ]
  #   resources = [data.aws_kms_key.extract_key.arn]
  # }
  # # -------------------------------- END -------------------------------------------

}

# ECS task role for S3 access
resource "aws_iam_role" "s3_ecs_task_role" {
  name               = "s3_ecs_task_role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
{
  "Action": "sts:AssumeRole",
  "Principal": {
    "Service": "ecs-tasks.amazonaws.com"
  },
  "Effect": "Allow",
  "Sid": ""
}
]
}
EOF

  tags = {
    Name = "arcdemo-taskrole"
  }
}

resource "aws_iam_role_policy" "ecs_task_role" {
  name   = "s3_ecs_task"
  role   = aws_iam_role.s3_ecs_task_role.id
  policy = data.aws_iam_policy_document.s3_ecs_task_role.json
}

