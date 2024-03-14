resource "aws_eip" "nat" {

  domain = "vpc"

  tags = {
    Name = "${terraform.workspace}-eip-us-east-1a"
    env = "${terraform.workspace}"
    layer = "networking"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${terraform.workspace}-nat-public1-us-east-1a"
    env = "${terraform.workspace}"
    layer = "networking"
  }
  lifecycle {
    create_before_destroy = true
  }
}