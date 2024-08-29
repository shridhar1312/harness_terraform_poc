# backend.tf

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "shridhar131296"
  #acl    = "private"

  tags = {
    Name = "terraform-state"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "shridhar131296"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}
