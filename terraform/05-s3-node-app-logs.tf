
resource "aws_s3_bucket" "node_app_logs" {
    bucket_prefix = "node-app-logs-"
    tags                        = {
        "Name" = "node-app-logs"
    }
}

resource "aws_s3_bucket_versioning" "node_app_logs_bucket_versioning" {
  bucket = aws_s3_bucket.node_app_logs.id
    versioning_configuration {
        status = "Enabled"
    }
}
