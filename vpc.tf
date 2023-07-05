# Create AWS_VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Prod-VPC"
  }
}

# Create Public_Subnets
resource "aws_subnet" "Public-subnet-1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Prod-Pub-Sub1"
  }
}

resource "aws_subnet" "Public-subnet-2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Prod-Pub-Sub2"
  }
}

# Create Private_subnets
resource "aws_subnet" "Private-subnet-1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Prod-Priv-Sub1"
  }
}

resource "aws_subnet" "Private-subnet-2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Prod-Priv-Sub2"
  }
}

# Create Internet Gateway and Attach to VPC
resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Prod-igw"
  }
}

# Create Route Table and Add Public Route
resource "aws_route_table" "Public-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Public Route Table"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-1" {
  subnet_id      = aws_subnet.Public-subnet-1.id
  route_table_id = aws_route_table.Public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
resource "aws_route_table_association" "public-subnet-2" {
  subnet_id      = aws_subnet.Public-subnet-2.id
  route_table_id = aws_route_table.Public-route-table.id
}

resource "aws_eip" "nateIP" {
  vpc = true
}

# Creating the NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "NATgw" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.Public-subnet-1.id
}

# Create Route Table and Add Private Route
resource "aws_route_table" "Private-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Private Route Table"
  }
}

# Associate Private Subnet 1 to "Private Route Table"
resource "aws_route_table_association" "private-subnet-1" {
  subnet_id      = aws_subnet.Private-subnet-1.id
  route_table_id = aws_route_table.Private-route-table.id
}

# Associate Private Subnet 2 to "Private Route Table"
resource "aws_route_table_association" "private-subnet-2" {
  subnet_id      = aws_subnet.Private-subnet-2.id
  route_table_id = aws_route_table.Private-route-table.id
}

# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.Public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Prod-igw.id
}

# Route for NAT Gateway
resource "aws_route" "private_internet_gateway" {
  route_table_id         = aws_route_table.Private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.NATgw.id
}




