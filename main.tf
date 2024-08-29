# main.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "example_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = "example_lambda_function"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  environment {
    variables = {
      key = "value"
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
