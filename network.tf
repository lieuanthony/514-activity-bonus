# VPC and Networking Resources
# Create a VPC, subnets, and related networking infrastructure for WordPress.

# VPC
resource "aws_vpc" "wordpress_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "WordPress VPC"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "WordPress Public Subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "WordPress Private Subnet"
  }
}

# Internet Gateway for Public Access
resource "aws_internet_gateway" "wordpress_igw" {
  vpc_id = aws_vpc.wordpress_vpc.id
  tags = {
    Name = "WordPress Internet Gateway"
  }
}
# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.wordpress_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wordpress_igw.id
  }
  tags = {
    Name = "WordPress Public Route Table"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


# DB Subnet Group
resource "aws_db_subnet_group" "wordpress_db_subnet_group" {
  name       = "wordpress_db_subnet_group"
  subnet_ids = [aws_subnet.private_subnet.id, aws_subnet.public_subnet.id]

  tags = {
    Name = "WordPress DB Subnet Group"
  }
}
