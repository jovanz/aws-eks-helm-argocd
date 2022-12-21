# Main VPC
resource "aws_vpc" "eks_main_vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "${var.default_tags.Project}-${var.default_tags.Environment}-vpc"
  }
}

# Public Subnet
resource "aws_subnet" "eks_public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.eks_main_vpc.id
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(aws_vpc.eks_main_vpc.cidr_block, 4, count.index)

  tags = {
    "Name" = "${var.default_tags.Project}-${var.default_tags.Environment}-public-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Public Route Table
resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_main_vpc.id

  tags = {
    "Name" = "${var.default_tags.Project}-${var.default_tags.Environment}-public-route-table"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_main_vpc.id

  tags = {
    "Name" = "${var.default_tags.Project}-${var.default_tags.Environment}-internet-gateway"
  }
}

# Public Routes
resource "aws_route" "eks_public_internet_access" {
  route_table_id         = aws_route_table.eks_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id

  depends_on = [
    aws_route_table.eks_public_rt
  ]
}

# Public Subnet Route Associations
resource "aws_route_table_association" "eks_public_rta" {
  count          = var.public_subnet_count
  subnet_id      = element(aws_subnet.eks_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.eks_public_rt.id
}

# Private Subnet
resource "aws_subnet" "eks_private_subnet" {
  count             = var.private_subnet_count
  vpc_id            = aws_vpc.eks_main_vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.eks_main_vpc.cidr_block, 4, count.index + var.public_subnet_count)

  tags = {
    "Name" = "${var.default_tags.Project}-${var.default_tags.Environment}-private-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Private Route Table
resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_main_vpc.id

  tags = {
    "Name" = "${var.default_tags.Project}-${var.default_tags.Environment}-public-route-table"
  }
}

# The NAT Elastic IP
resource "aws_eip" "eks_nat_eip" {
  vpc = true

  tags = {
    "Name" = "${var.default_tags.Project}-${var.default_tags.Environment}-nat-eip"
  }
}

resource "aws_nat_gateway" "eks_nat_gtw" {
  allocation_id = aws_eip.eks_nat_eip.id
  subnet_id     = aws_subnet.eks_public_subnet.0.id

  depends_on = [
    aws_eip.eks_nat_eip,
    aws_internet_gateway.eks_igw
  ]

  tags = {
    "Name" = "${var.default_tags.Project}-${var.default_tags.Environment}-nat-gtw"
  }
}

# Private Routes
resource "aws_route" "eks_private_internet_access" {
  route_table_id         = aws_route_table.eks_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.eks_nat_gtw.id

  depends_on = [
    aws_route_table.eks_private_rt
  ]
}

# Private Subnet Route Associations
resource "aws_route_table_association" "eks_privte_rta" {
  count          = var.private_subnet_count
  subnet_id      = element(aws_subnet.eks_private_subnet.*.id, count.index)
  route_table_id = aws_route_table.eks_private_rt.id
}
