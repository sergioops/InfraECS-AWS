resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_blocks[terraform.workspace]
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-vpc"
    env = "${terraform.workspace}"
    layer = "networking"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-igw"
    env = "${terraform.workspace}"
    layer = "networking"
  }
}