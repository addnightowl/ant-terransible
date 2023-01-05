# --- ant-terransible/networking.tf ---

locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_availability_zones" "available" {}

resource "random_id" "random" {
  byte_length = 2
}


resource "aws_vpc" "ant_vpc" {
  cidr_block  = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ant_vpc-${random_id.random.dec}"
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_internet_gateway" "ant_igw" {
  vpc_id = aws_vpc.ant_vpc.id

  tags = {
    Name = "ant_igw-${random_id.random.dec}"
  }
}


resource "aws_route_table" "ant_public_rt" {
  vpc_id = aws_vpc.ant_vpc.id

  tags = {
    Name = "ant_public_rt"
  }
}


resource "aws_route" "ant_default_route" {
  route_table_id  = aws_route_table.ant_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ant_igw.id
}


resource "aws_default_route_table" "ant_private_rt" {
  default_route_table_id = aws_vpc.ant_vpc.default_route_table_id

  tags = {
    Name = "ant_private_rt"
  }
}

resource "aws_subnet" "ant_public_subnet" {
  count                   = length(local.azs)
  vpc_id                  = aws_vpc.ant_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "ant_public_${count.index + 1}"
  }
}

resource "aws_subnet" "ant_private_subnet" {
  count        = length(local.azs)
  vpc_id               = aws_vpc.ant_vpc.id
  cidr_block       = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.azs))
  map_public_ip_on_launch = false
  availability_zone       = local.azs[count.index]

  tags = {
    Name = "ant_private_${count.index + 1}"
  }
}

resource "aws_route_table_association" "ant_public_assoc" {
  count          = length(local.azs)
  subnet_id      = aws_subnet.ant_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.ant_public_rt.id
}

resource "aws_security_group" "ant_sg" {
  name        = "ant_public_sg"
  description = "Security group for public instances"
  vpc_id      = aws_vpc.ant_vpc.id
}

resource "aws_security_group_rule" "ingress_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.access_ip, var.cloud9_ip]
  security_group_id = aws_security_group.ant_sg.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ant_sg.id
}

