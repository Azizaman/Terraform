# resource "aws_s3_bucket" "s3_bucket" {
#     bucket="cw-log-archive-${var.project_name}"
#     lifecycle_rule{
#         id="expired-logs"
#         enabled=true
#         transition{
#         storage_class="STANDARD_IA"
#         days=30
#     }
#     expiration{
#         days=60
#     }   
#     }
# }


resource "aws_s3_bucket" "log_archive" {
  bucket = "${var.project_name}-log-archive-bucket"     
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "log_archive" {
  bucket = aws_s3_bucket.log_archive.id

  versioning_configuration {
    status = "Enabled"
  }
}



