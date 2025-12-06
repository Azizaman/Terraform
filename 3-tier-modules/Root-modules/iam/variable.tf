variable "iam_role_name" {
    type = string
    default = "EC2-CloudWatch-LogRole"
}

# variable "instance_profile_name" {
#     type = string
#     default = "EC2-CloudWatch-LogProfile"
# }
variable "s3_access_role_name" {
    type = string
}
variable "s3_access_instance_profile_name" {
    type = string
}

variable "lambda_s3_ec2_access_role_name"{
    type = string
    description = "Name of the IAM role for lambda to access s3 and ec2"
}

variable "lambda_s3_ec2_access_instance_profile_name" {
    type = string
    description = "Name of the IAM instance profile for lambda to access s3 and ec2"
}
variable "log_archive_bucket_arn" {
  type = string
}

