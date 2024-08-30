resource "aws_iam_role" "ccl_phf_dataloading_lambda_role" {
  name               = "${var.app_ci}-PHFdataloadingLambdaRole-${var.env_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action   = "sts:AssumeRole"
      }
    ]
  })
  
  tags = {
    Name                = "${var.app_ci}-PHFdataloadingLambdaRole-${var.env_name}"
    ApplicationCI       = var.app_ci
    ApplicationContactDL = var.application_contact_dl
    InternalExternal    = var.internal_external
    MaintenanceWindow   = var.maintenance_window
    RiskDataClass       = var.risk_data_class
    SLALevel            = var.sla_level
    RegulatoryControls  = var.regulatory_controls
  }
}


# data_sources.tf
data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "ccl_phf_dataloading_lambda_policy" {
  name        = "${var.app_ci}-PHFdataloadingLambda-${var.env_name}"
  description = "Policy for Lambda function ${var.app_ci}-PHFdataloadingLambda-${var.env_name}"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "LambdaSNS"
        Effect = "Allow"
        Action = [
          "sns:ListSubscriptionsByTopic",
          "sns:GetTopicAttributes",
          "sns:ListTagsForResource",
          "sns:TagResource",
          "sns:UntagResource",
          "sns:Publish",
          "sns:Subscribe",
          "sns:ConfirmSubscription",
          "sns:ListTopics"
        ]
        Resource = "arn:aws:sns:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Sid    = "SQSFull"
        Effect = "Allow"
        Action = [
          "sqs:AddPermission",
          "sqs:ChangeMessageVisibility",
          "sqs:ChangeMessageVisibilityBatch",
          "sqs:CreateQueue",
          "sqs:DeleteMessage",
          "sqs:DeleteMessageBatch",
          "sqs:DeleteQueue",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ListDeadLetterSourceQueues",
          "sqs:ListQueueTags",
          "sqs:ListQueues",
          "sqs:PurgeQueue",
          "sqs:ReceiveMessage",
          "sqs:RemovePermission",
          "sqs:SendMessage",
          "sqs:SendMessageBatch",
          "sqs:SetQueueAttributes",
          "sqs:TagQueue",
          "sqs:UntagQueue"
        ]
        Resource = "arn:aws:sqs:*:${data.aws_caller_identity.current.account_id}:${var.app_ci}*"
      },
      {
        Sid    = "DynamoDBPermissions"
        Effect = "Allow"
        Action = "dynamodb:*"
        Resource = "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/*"
      },
      {
        Sid    = "cclS3BucketListPermissions"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:ListAllMyBuckets"
        ]
        Resource = "arn:aws:s3:::*"
      },
      {
        Sid    = "cclS3BucketPermissions"
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.app_ci}*/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ccl_phf_dataloading_lambda_policy_attachment" {
  policy_arn = aws_iam_policy.ccl_phf_dataloading_lambda_policy.arn
  role      = aws_iam_role.ccl_phf_dataloading_lambda_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.ccl_phf_dataloading_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_access" {
  role       = aws_iam_role.ccl_phf_dataloading_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

resource "aws_lambda_function" "ccl_scheduled_trigger_lambda" {
  function_name = "${var.app_ci}-PHFdataloadingLambda-${var.env_name}"
  s3_bucket     = var.s3_bucket_name
  s3_key        = var.s3_script_key
  handler       = "index.lambda_handler"
  runtime       = var.lambda_runtime
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  role = aws_iam_role.ccl_phf_dataloading_lambda_role.arn

  environment {
    variables = {
      ccl_table_name = var.ccl_table_name
    }
  }

#   vpc_config {
#     subnet_ids          = [var.app_subnet_a, var.app_subnet_b]
#     security_group_ids   = ["${module.baseline_security_group_tgw.security_group_id}"] # This assumes you have a module or resource defining the security group
#   }

  tags = {
    ApplicationCI        = var.app_ci
    SLALevel             = var.sla_level
    RiskDataClass        = var.risk_data_class
    ApplicationContactDL = var.application_contact_dl
    MaintenanceWindow    = var.maintenance_window
    InternalExternal     = var.internal_external
    DataRetentionPeriod  = var.data_retention_period
    Name                 = "${var.app_ci}-PHFdataloadingLambda-${var.env_name}"
    RegulatoryControls   = var.regulatory_controls
  }
}
