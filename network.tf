#Create VPC and IGW
resource "aws_vpc" "vpc_egress" {
    cidr_block = "${lookup(var.vpc_egress,"cidr")}"
    enable_dns_support = var.enable_dns_hostnames
    
    tags = {
        Name = "${local.name_prefix}-${lookup(var.vpc_egress,"name")}"
    }
}

resource "aws_vpc" "vpc_spoke1" {
    cidr_block = "${lookup(var.vpc_spoke1,"cidr")}"
    enable_dns_support = var.enable_dns_hostnames
    tags = {
        Name = "${local.name_prefix}-${lookup(var.vpc_spoke1,"name")}"
    }
}

resource "aws_vpc" "vpc_spoke2" {
    cidr_block = "${lookup(var.vpc_spoke2,"cidr")}"
    enable_dns_support = var.enable_dns_hostnames
    tags = {
        Name = "${local.name_prefix}-${lookup(var.vpc_spoke2,"name")}"
    }
}

resource "aws_vpc" "vpc_onprem" {
    cidr_block = "${lookup(var.vpc_onprem,"cidr")}"
    enable_dns_support = var.enable_dns_hostnames
    tags = {
        Name = "${local.name_prefix}-${lookup(var.vpc_onprem,"name")}"
    }
}


resource "aws_internet_gateway" "igw_egress" {
    vpc_id = aws_vpc.vpc_egress.id
    tags = {
        Name = "${local.name_prefix}-${lookup(var.vpc_egress,"name")}-igw"
    }
}

resource "aws_internet_gateway" "igw_onprem" {
    vpc_id = aws_vpc.vpc_onprem.id
    tags = {
        Name = "${local.name_prefix}-${lookup(var.vpc_onprem,"name")}-igw"
    }
}

resource "aws_eip" "eip_nat_egress" {
  vpc      = true
  tags = {
    Name = "${local.name_prefix}-${lookup(var.public_subnets_egress_NATGW_subnet,"name")}-eip"
  }
}


resource "aws_nat_gateway" "nat_egress" {
  subnet_id     = "${aws_subnet.public_subnets_egress_NATGW_subnet.id}"
  allocation_id = "${aws_eip.eip_nat_egress.id}"
  tags          = {
    Name        = "${local.name_prefix}-${lookup(var.vpc_egress,"name")}-natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw_egress]
}



#Create subnets
resource "aws_subnet" "private_subnets_spoke1" {
    vpc_id                 = aws_vpc.vpc_spoke1.id
    availability_zone      = var.aws_availability_zones
    cidr_block             = "${lookup(var.private_subnets_spoke1,"cidr")}"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.private_subnets_spoke1,"name")}"
    }
}

resource "aws_subnet" "private_subnets_spoke2" {
    vpc_id                 = aws_vpc.vpc_spoke2.id
    availability_zone      = var.aws_availability_zones
    cidr_block             = "${lookup(var.private_subnets_spoke2,"cidr")}"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.private_subnets_spoke2,"name")}"
    }
}

resource "aws_subnet" "public_subnets_onprem" {
    vpc_id                 = aws_vpc.vpc_onprem.id
    availability_zone      = var.aws_availability_zones
    cidr_block             = "${lookup(var.public_subnets_onprem,"cidr")}"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.public_subnets_onprem,"name")}"
    }
}


resource "aws_subnet" "private_subnets_egress_mgmt_tgw" {
    vpc_id                 = aws_vpc.vpc_egress.id
    availability_zone      = var.aws_availability_zones
    cidr_block             = "${lookup(var.private_subnets_egress_mgmt_tgw,"cidr")}"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.private_subnets_egress_mgmt_tgw,"name")}"
    }
}

resource "aws_subnet" "private_subnets_egress_data_subnet" {
    vpc_id                 = aws_vpc.vpc_egress.id
    availability_zone      = var.aws_availability_zones
    cidr_block             = "${lookup(var.private_subnets_egress_data_subnet,"cidr")}"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.private_subnets_egress_data_subnet,"name")}"
    }
}

resource "aws_subnet" "private_subnets_egress_GWLBE_subnet" {
    vpc_id                 = aws_vpc.vpc_egress.id
    availability_zone      = var.aws_availability_zones
    cidr_block             = "${lookup(var.private_subnets_egress_GWLBE_subnet,"cidr")}"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.private_subnets_egress_GWLBE_subnet,"name")}"
    }
}


resource "aws_subnet" "public_subnets_egress_NATGW_subnet" {
    vpc_id                 = aws_vpc.vpc_egress.id
    availability_zone      = var.aws_availability_zones
    cidr_block             = "${lookup(var.public_subnets_egress_NATGW_subnet,"cidr")}"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.public_subnets_egress_NATGW_subnet,"name")}"
    }
}



