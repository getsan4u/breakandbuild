##
## VPC | Route Table | NAT | IGW
##

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

    tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
    Service     = var.service
    Tier        = "Default"
  }

}

resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24" # Changed CIDR block "10.0.1.0/24
  map_public_ip_on_launch = true

    tags = {
    Name        = "${var.environment}-public-1-subnet"
    Environment = var.environment
    Service     = var.service
    Tier        = "Public"
  }

}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24" # Changed CIDR block "10.0.2.0/24
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

    tags = {
    Name        = "${var.environment}-public-2-subnet"
    Environment = var.environment
    Service     = var.service
    Tier        = "Public"
  }

}


resource "aws_subnet" "web-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24" # Changed CIDR block "10.0.3.0/24
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = false

   tags = {
    Name        = "${var.environment}-web-1-subnet"
    Environment = var.environment
    Service     = var.service
    Tier        = "Web"
  }

}

resource "aws_subnet" "web-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24" # Changed CIDR block "10.0.4.0/24
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = false

   tags = {
    Name        = "${var.environment}-web-2-subnet"
    Environment = var.environment
    Service     = var.service
    Tier        = "Web"
  }

}

resource "aws_subnet" "database-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.5.0/24" # Changed CIDR block "10.0.5.0/24
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = false

    tags = {
    Name        = "${var.environment}-database-1-subnet"
    Environment = var.environment
    Service     = var.service
    Tier        = "Database"
  }

}

resource "aws_subnet" "database-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.6.0/24" # Changed CIDR block "10.0.6.0/24
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = false


    tags = {
    Name        = "${var.environment}-database-2-subnet"
    Environment = var.environment
    Service     = var.service
    Tier        = "Database"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Fixed CIDR block
    gateway_id = aws_internet_gateway.igw.id
  }

    tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = var.environment
    Service     = var.service
    Tier     = "Public Route Table"
  }

}

//IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-internet-gateway"
    Environment = var.environment
    Service     = var.service
    Tier     = "Internet Gateway"
  }

}

//Route Table 

resource "aws_route_table" "rt_aza" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-az-a.id
  }
  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = var.environment
    Service     = var.service
    Tier     = "Private Route Table"
  }

}

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.public.id
  
  }


resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id
  route_table_id = aws_route_table.public.id
}



resource "aws_route_table_association" "web_aza" {
  subnet_id      = aws_subnet.web-1.id
  route_table_id = aws_route_table.rt_aza.id
}

resource "aws_route_table_association" "web_azb" {
  subnet_id      = aws_subnet.web-2.id
  route_table_id = aws_route_table.rt_aza.id
}



//NAT Gateway

resource "aws_nat_gateway" "nat-az-a" {
  subnet_id     = aws_subnet.public-1.id
  allocation_id = aws_eip.nat_a.id


  depends_on = [
    aws_subnet.public-1
  ]
    tags = {
    Name        = "${var.environment}-nat-gateway-az-a"
    Environment = var.environment
    Service     = var.service
    Tier     = "NAT Gateway"
  }

}

//Elastic IP for NAT Gateway

resource "aws_eip" "nat_a" {
  domain = "vpc" # vpc Argument is deprecated

    tags = {
    Name        = "${var.environment}-nat-eip"
    Environment = var.environment
    Service     = var.service
    Purpose     = "Elastic IP for NAT"
  }

}