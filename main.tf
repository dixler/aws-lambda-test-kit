provider "aws" {
  region = "us-east-1"
}

variable "prefix" {
  type = "string"
  default = "dev"
}

output "lambda-target" {
  value = "${aws_lambda_function.test_lambda.function_name}"
}

resource "aws_iam_role" "iam_for_lambda" {

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "admin-attach" {
    role       = "${aws_iam_role.iam_for_lambda.name}"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_dynamodb_table" "dev-table" {
  name           = "${var.prefix}-dev-table"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "primary-key"

  attribute {
    name = "primary-key"
    type = "S"
  }
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = "${var.prefix}-dev-lambda"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "lambda_handler.lambda_handler"
  source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  runtime          = "python3.6"

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = "${aws_dynamodb_table.dev-table.name}"
    }
  }
}
