resource "aws_s3_bucket" "node-app-backup" {
  bucket = "node-app-backup"
    tags                        = {
        "Name" = "node-app-backup"
    }
    tags_all                    = {
        "Name" = "node-app-backup"
    }
}

