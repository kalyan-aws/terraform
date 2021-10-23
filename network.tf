resource "aws_vpc" "myvpc" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = "POC_VPC"
  }

}

