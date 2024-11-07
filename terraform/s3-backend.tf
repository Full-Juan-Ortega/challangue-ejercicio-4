
terraform {
  backend "s3" {
    bucket         = "juan-ej02"
    key            = "./terraform.tfstate"
    region         = "us-east-1"
  }
}