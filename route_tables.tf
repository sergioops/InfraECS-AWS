resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-rtb-public"
    env = "${terraform.workspace}"
    layer = "networking"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${terraform.workspace}-rtb-private"
    env = "${terraform.workspace}"
    layer = "networking"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.subnet_cidr_blocks[terraform.workspace]["public"])

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.subnet_cidr_blocks[terraform.workspace]["private"])

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
  lifecycle {
    create_before_destroy = true
  }

}