# Output the S3 bucket name
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.bucket
}

# Output the bucket region
output "bucket_region" {
  description = "The AWS region of the S3 bucket"
  value       = var.region
}
