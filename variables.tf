variable "env_name" {
  description = "Environment name for creating resources"
  default     = "qa"
}

variable "app_ci" {
  description = "Lowercase AppCI"
  default     = "shri"
}

variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "upper_case_app_ci" {
  description = "Uppercase AppCI"
  default     = "CCL"
}

variable "sla_level" {
  description = "SLA Level"
  default     = "Tier 1"
}

variable "risk_data_class" {
  description = "Risk Data Classification"
  default     = "No Risk"
}

variable "application_contact_dl" {
  description = "Application Contact Distribution List"
  default     = "ATW_DevOps@united.com"
}

variable "maintenance_window" {
  description = "Maintenance Window"
  default     = "never"
}

variable "internal_external" {
  description = "Internal or External"
  default     = "internal"
}

variable "data_retention_period" {
  description = "Data Retention Period"
  default     = "2 years"
}

variable "regulatory_controls" {
  description = "Regulatory Controls"
  default     = "None"
}

variable "lambda_runtime" {
  description = "Lambda runtime to use"
  default     = "python3.9"
  validation {
    condition     = contains(["nodejs", "nodejs4.3", "nodejs6.10", "nodejs8.10", "java8", "python2.7", "python3.6", "dotnetcore1.0", "dotnetcore2.0", "dotnetcore2.1", "nodejs4.3-edge", "go1.x", "python3.9"], var.lambda_runtime)
    error_message = "Invalid Lambda runtime"
  }
}

variable "lambda_memory_size" {
  description = "Lambda Memory Size"
  default     = "256"
}

variable "lambda_timeout" {
  description = "Lambda Timeout"
  default     = "900"
}

variable "ccl_table_name" {
  description = "DynamoDB table name"
  default     = "ccl-PHF-dataloading"
}

variable "app_subnet_a" {
  description = "Subnet A"
  default     = "subnet-0f7dfda96170bfa41"
}

variable "app_subnet_b" {
  description = "Subnet B"
  default     = "subnet-0b4de00711efa727e"
}

variable "s3_bucket_name" {
  description = "S3 bucket name containing the Python script"
  default     = "shri-s3-qa"
}

variable "s3_script_key" {
  description = "S3 key for the Python script"
  default     = "CCL-Lambda-Functions/phfDataLoading.zip"
}
