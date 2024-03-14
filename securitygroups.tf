resource "aws_security_group" "rede-interna" {
  description = "Rede Interna ${terraform.workspace}"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = [
      aws_vpc.main.cidr_block
    ]
    description = "Rede Interna ${terraform.workspace}"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  name   = "Rede Interna ${terraform.workspace}"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Rede Interna ${terraform.workspace}"
    env = "${terraform.workspace}"
    layer = "networking"
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes =  all
  }
}

resource "aws_security_group" "loadbalancer" {
  description = "Loadbalancer ${terraform.workspace}"
  name        = "Loadbalancer ${terraform.workspace}"
  tags = {
    Name = "Loadbalancer ${terraform.workspace}"
    env = "${terraform.workspace}"
    layer = "networking"
  }
  vpc_id = aws_vpc.main.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
  }
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
  }
  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
  lifecycle {
    create_before_destroy = true
  }
}
