#Modify the default rtb of spoke1 and associate with subnet
resource "aws_default_route_table" "spoke1_default" {
  default_route_table_id = aws_vpc.vpc_spoke1.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke2,"cidr")}"
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
    Name = "${local.name_prefix}-${lookup(var.vpc_spoke1,"name")}-rtb"
  }
}

resource "aws_route_table_association" "spoke1_default_subnet" {
  subnet_id      = aws_subnet.private_subnets_spoke1.id
  route_table_id = aws_default_route_table.spoke1_default.id
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
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_onprem.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke1,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke2,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_egress,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  tags = {
    Name = "${local.name_prefix}-${lookup(var.vpc_onprem,"name")}-rtb"
  }
}
resource "aws_route_table_association" "onprem_default_subnet" {
  subnet_id      = aws_subnet.public_subnets_onprem.id
  route_table_id = aws_default_route_table.onprem_default.id
}
########################################################################
#Create new rtb for subnet mgmt_tgw
resource "aws_route_table" "rtb_egress_mgmt_tgw" {
  vpc_id = aws_vpc.vpc_egress.id
  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id  = aws_vpc_endpoint.gwlb_endpoint.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke1,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke2,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_onprem,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
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
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_egress.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke1,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke2,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
  route {
    cidr_block = "${lookup(var.vpc_onprem,"cidr")}"
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
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
    cidr_block = "${lookup(var.vpc_spoke1,"cidr")}"
    vpc_endpoint_id  = aws_vpc_endpoint.gwlb_endpoint.id
  }
  route {
    cidr_block = "${lookup(var.vpc_spoke2,"cidr")}"
    vpc_endpoint_id  = aws_vpc_endpoint.gwlb_endpoint.id
  }
  route {
    cidr_block = "${lookup(var.vpc_onprem,"cidr")}"
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


