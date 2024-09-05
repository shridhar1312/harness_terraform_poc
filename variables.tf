# Define input variables
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "region" {
  description = "The AWS region to create the S3 bucket in"
  type        = string
}

variable "environment" {
  description = "The environment in which the bucket will be used"
  type        = string
  default     = "dev"
}
