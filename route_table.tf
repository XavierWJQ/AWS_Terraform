#Modify the default rtb of spoke1 and associate with subnet
resource "aws_default_route_table" "spoke1_default" {
  default_route_table_id = aws_vpc.vpc_spoke1.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = aws_vpc_endpoint.spoke1_endpoint.id
  }
  route {
    cidr_block = "192.168.10.0/24"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name = "${local.name_prefix}-${lookup(var.vpc_spoke1,"name")}-rtb"
  }
}
resource "aws_route_table_association" "spoke1_default_subnet" {
  subnet_id      = aws_subnet.private_subnets_spoke1.id
  route_table_id = aws_default_route_table.spoke1_default.id
}


########################################################################
#create rtb for spoke1 endpoint subnet

resource "aws_route_table" "spoke1_endpoint" {
  vpc_id = aws_vpc.vpc_spoke1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_spoke1.id
  }
  tags = {
    Name = "rtb-spoke1-ep"
  }
}
resource "aws_route_table_association" "spoke1_endpoint" {
  subnet_id      = aws_subnet.public_subnets_spoke1.id
  route_table_id = aws_route_table.spoke1_endpoint.id
}

########################################################################
#create rtb for spoke1 edge subnet
resource "aws_route_table" "spoke1_edge" {
  vpc_id = aws_vpc.vpc_spoke1.id
  route {
    cidr_block = "192.168.3.0/26"
    vpc_endpoint_id  = aws_vpc_endpoint.spoke1_endpoint.id
  }
  tags = {
    Name = "rtb-spoke1-ep"
  }
}

resource "aws_route_table_association" "spoke1_edge" {
  gateway_id     = aws_internet_gateway.igw_spoke1.id
  route_table_id = aws_route_table.spoke1_edge.id
}

########################################################################
#Modify the default rtb of spoke2 and associate with subnet
resource "aws_default_route_table" "spoke2_default" {
  default_route_table_id = aws_vpc.vpc_spoke2.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke1,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_onprem,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_egress,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name = "${local.name_prefix}-${lookup(var.vpc_spoke2,"name")}-rtb"
  }
}

resource "aws_route_table_association" "spoke2_default_subnet" {
  subnet_id      = aws_subnet.private_subnets_spoke2.id
  route_table_id = aws_default_route_table.spoke2_default.id
}
#########################################################################
#Modify the default rtb of onprem and associate with subnet
resource "aws_default_route_table" "onprem_default" {
  default_route_table_id = aws_vpc.vpc_onprem.default_route_table_id
  route {
    cidr_block = "193.57.249.5/32"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "88.160.66.32/32"
    gateway_id = aws_internet_gateway.igw_onprem.id
  }
  route {
    cidr_block = "88.167.34.137/32"
    gateway_id = aws_internet_gateway.igw_onprem.id
  }
    route {
    cidr_block = "91.172.216.161/32"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "194.4.230.0/24"
    gateway_id = aws_internet_gateway.igw_onprem.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name = "rtb-${local.name_prefix}-${lookup(var.vpc_onprem,"name")}"
  }
}
resource "aws_route_table_association" "onprem_private" {
  subnet_id      = aws_subnet.public_subnets_onprem.id
  route_table_id = aws_default_route_table.onprem_default.id
}

########################################################################
#create rtb for onprem endpoint subnet
resource "aws_route_table" "onprem_endpoint" {
  vpc_id = aws_vpc.vpc_onprem.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_onprem.id
  }
  route {
    cidr_block = "192.168.0.0/20"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name = "rtb-${local.name_prefix}-${lookup(var.public_subnets_onprem_endpoint,"name")}"
  }
}
resource "aws_route_table_association" "onprem_endpoint" {
  subnet_id      = aws_subnet.public_subnets_onprem_endpoint.id
  route_table_id = aws_route_table.onprem_endpoint.id
}

###########################################################################
#Create new rtb onprem-edge
resource "aws_route_table" "onprem_edge" {
  vpc_id = aws_vpc.vpc_onprem.id
  route {
    cidr_block = "80.214.30.23/32"
    gateway_id = aws_internet_gateway.igw_onprem.id
  }
  tags = {
    Name = "onprem-edge"
  }
}


########################################################################
#Create new rtb for subnet mgmt_tgw
resource "aws_route_table" "rtb_egress_mgmt_tgw" {
  vpc_id = aws_vpc.vpc_egress.id
  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id  = aws_vpc_endpoint.gwlb_endpoint.id
  }
  tags = {
    Name = "rtb-mgmt-tgw-${lookup(var.vpc_egress,"name")}"
  }
}

resource "aws_route_table_association" "mgmt_tgw_subnet" {
  subnet_id      = aws_subnet.private_subnets_egress_mgmt_tgw.id
  route_table_id = aws_route_table.rtb_egress_mgmt_tgw.id
}
#######################################################################
#Create new rtb for subnet gwlbe
resource "aws_route_table" "rtb_gwlbe" {
  vpc_id = aws_vpc.vpc_egress.id
  route {
    cidr_block = "192.168.0.0/20"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_egress.id
  }
  tags = {
    Name = "rtb-gwlbe-${lookup(var.vpc_egress,"name")}"
  }
}
resource "aws_route_table_association" "gwlbe_subnet" {
  subnet_id      = aws_subnet.private_subnets_egress_GWLBE_subnet.id
  route_table_id = aws_route_table.rtb_gwlbe.id
}
###########################################################################
#Create new rtb for subnet natgw
resource "aws_route_table" "rtb_nat" {
  vpc_id = aws_vpc.vpc_egress.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_egress.id
  }
  route {
    cidr_block = "192.168.0.0/20"
    vpc_endpoint_id  = aws_vpc_endpoint.gwlb_endpoint.id
  }
  tags = {
    Name = "rtb-nat-${lookup(var.vpc_egress,"name")}"
  }
}
resource "aws_route_table_association" "natgw_subnet" {
  subnet_id      = aws_subnet.public_subnets_egress_NATGW_subnet.id
  route_table_id = aws_route_table.rtb_nat.id
}

########################################################################
#Create new rtb for subnet data
resource "aws_route_table" "rtb_data" {
  vpc_id = aws_vpc.vpc_egress.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_egress.id
  }
  route {
    cidr_block = "192.4.230.208/32"
    gateway_id = aws_internet_gateway.igw_egress.id
  }
}
resource "aws_route_table_association" "data_subnet" {
  subnet_id      = aws_subnet.private_subnets_egress_data_subnet.id
  route_table_id = aws_route_table.rtb_data.id
}

