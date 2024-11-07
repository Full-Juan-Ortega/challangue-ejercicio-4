# aws_vpc.vpc-node-app:
resource "aws_vpc" "vpc-node-app" {
    cidr_block                           = "10.1.0.0/16"
    enable_dns_hostnames                 = false
    enable_dns_support                   = true
    instance_tenancy                     = "default"
    tags                                 = {
        "Name" = "vpc-node-app"
    }
}
