terraform {
  backend "s3" {
    bucket         = "shridhar1312"          # Replace with your S3 bucket name
    key            = "terraform.tfstate" # Path to the state file within the bucket
    region         = "us-east-1"                    # AWS region where the S3 bucket is located
    encrypt        = true                           # Encrypt the state file
    dynamodb_table = "shridhar1312"     # Replace with your DynamoDB table for state locking
  }
}
