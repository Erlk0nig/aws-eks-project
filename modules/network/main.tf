resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.fullname}-${var.env}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.fullname}-${var.env}-igw"
  }
  depends_on = [aws_vpc.main]
}

# 2 Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index].cidr_block
  map_public_ip_on_launch = true
  availability_zone = var.public_subnets[count.index].availability_zone
  tags = {
    Name = "${var.fullname}-${var.env}-${var.public_subnets[count.index].name}"
  }
  depends_on = [aws_vpc.main]
}


# 2 Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index].cidr_block
  map_public_ip_on_launch = false
  availability_zone = var.private_subnets[count.index].availability_zone
  tags = {
    Name = "${var.fullname}-${var.env}-${var.private_subnets[count.index].name}"
  }
  depends_on = [aws_vpc.main]
}


# ELastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  domain = "vpc"
  tags = {
    Name = "${var.fullname}-${var.env}-eip-${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway
resource "aws_nat_gateway" "main" {
  count = length(var.private_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.fullname}-${var.env}-nat-gw-${count.index + 1}"
  }

  depends_on = [aws_subnet.public, aws_eip.nat]
}

# Public Route Tables
resource "aws_route_table" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.fullname}-${var.env}-public-rt-${count.index + 1}"
  }
  depends_on = [aws_internet_gateway.main, aws_subnet.public]
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[count.index].id
  depends_on = [aws_route_table.public, aws_subnet.public]
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.fullname}-${var.env}-private-rt-${count.index + 1}"
  }
  depends_on = [aws_nat_gateway.main, aws_subnet.private]
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
  depends_on = [aws_route_table.private, aws_subnet.private]
}


# Security Groups
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${var.fullname}-${var.env}-public-sg"
  }
  depends_on = [ aws_subnet.public ]
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Allow private access"
  vpc_id      = aws_vpc.main.id  
  tags = {
    Name = "${var.fullname}-${var.env}-private-sg"
  }
  depends_on = [ aws_subnet.private ]
}

# Rules
resource "aws_security_group_rule" "public_sg_rules" {
  for_each = var.public_subnet_sg_inbound_rules

  security_group_id        = aws_security_group.public_sg.id
  type                      = each.value.rule_type
  protocol                  = each.value.protocol
  from_port                 = each.value.from_port
  to_port                   = each.value.to_port
  cidr_blocks               = each.value.dst_cidr != "" ? [each.value.dst_cidr] : null
  source_security_group_id  = each.value.dst_sg != "" ? aws_security_group.private_sg.id : null

  depends_on = [aws_security_group.public_sg]
}

resource "aws_security_group_rule" "private_sg_rules" {
  for_each = var.private_subnet_sg_inbound_rules

  security_group_id        = aws_security_group.private_sg.id
  type                      = each.value.rule_type
  protocol                  = each.value.protocol
  from_port                 = each.value.from_port
  to_port                   = each.value.to_port
  cidr_blocks               = each.value.dst_cidr != "" ? [each.value.dst_cidr] : null
  source_security_group_id  = each.value.dst_sg != "" ? aws_security_group.public_sg.id : null

  depends_on = [aws_security_group.private_sg]
}