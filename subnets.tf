resource "aws_subnet" "public" {
  count = length(var.subnet_cidr_blocks[terraform.workspace]["public"])

  vpc_id                                         = aws_vpc.main.id
  cidr_block                                     = var.subnet_cidr_blocks[terraform.workspace]["public"][count.index]
  availability_zone                              = element(data.aws_availability_zones.available.names, count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "${terraform.workspace}-subnet-public${count.index+1}-us-east-${element(split("-", element(data.aws_availability_zones.available.names, count.index)), 2)}"
    env = "${terraform.workspace}"
    layer = "networking"
  }
  tags_all = {}
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "private" {
  count = length(var.subnet_cidr_blocks[terraform.workspace]["private"])

  vpc_id                                         = aws_vpc.main.id
  cidr_block                                     = var.subnet_cidr_blocks[terraform.workspace]["private"][count.index]
  availability_zone                              = element(data.aws_availability_zones.available.names, count.index)
  enable_dns64                                   = false
  enable_resource_name_dns_a_record_on_launch    = false
  enable_resource_name_dns_aaaa_record_on_launch = false
  ipv6_native                                    = false
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = "ip-name"
  tags = {
    Name = "${terraform.workspace}-subnet-private${count.index+1}-us-east-${element(split("-", element(data.aws_availability_zones.available.names, count.index)), 2)}"
    env = "${terraform.workspace}"
    layer = "networking"
  }
  tags_all = {}
  lifecycle {
    create_before_destroy = true
  }
}