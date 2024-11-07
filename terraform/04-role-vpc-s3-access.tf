resource "aws_iam_role" "vpc_s3_access_role" {
  name = "juan-vpc-S3-AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_policy" "vpc_s3_policy" {
  name        = "juan-vpc-S3-AccessPolicy"
  description = "Policy to access VPC and S3 bucket node-app-backup"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::node-app-backup",
          "arn:aws:s3:::node-app-backup/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_s3_policy_attachment" {
  role       = aws_iam_role.vpc_s3_access_role.name
  policy_arn = aws_iam_policy.vpc_s3_policy.arn
}
