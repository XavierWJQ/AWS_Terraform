resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Create a transit gateway to manage the traffics from egress to spokes and back"
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  tags                            = {
    Name                          = "${local.name_prefix}-tgw"
  }
}

resource "aws_ec2_transit_gateway_route_table" "rtb_spoke" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags                            = {
    Name                          = "${local.name_prefix}-rtb_spoke"
  }
}

resource "aws_ec2_transit_gateway_route_table" "rtb_hub" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags                            = {
    Name                          = "${local.name_prefix}-rtb_hub"
  }
}

###############################################################################################
#Create tgw attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke_1_tgw" {
  subnet_ids         = [aws_subnet.private_subnets_spoke1.id]
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id    
  vpc_id             = aws_vpc.vpc_spoke1.id
  tags               = {
    Name             = "${local.name_prefix}-${lookup(var.vpc_spoke1,"name")}-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke_2_tgw" {
  subnet_ids         = [aws_subnet.private_subnets_spoke2.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false         
  vpc_id             = aws_vpc.vpc_spoke2.id
  tags               = {
    Name             = "${local.name_prefix}-${lookup(var.vpc_spoke2,"name")}-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "onprem_tgw" {
  subnet_ids         = [aws_subnet.public_subnets_onprem.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false       
  vpc_id             = aws_vpc.vpc_onprem.id
  tags               = {
    Name             = "${local.name_prefix}-${lookup(var.vpc_onprem,"name")}-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "egress_tgw" {
  subnet_ids         = [aws_subnet.private_subnets_egress_mgmt_tgw.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id 
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false     
  vpc_id             = aws_vpc.vpc_egress.id
  tags               = {
    Name             = "${local.name_prefix}-${lookup(var.vpc_egress,"name")}-tgw"
  }
}

#########################################################################################
#Configure route table spoke
resource "aws_ec2_transit_gateway_route_table_association" "rt_ass_spoke_1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_1_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_spoke.id
}

resource "aws_ec2_transit_gateway_route_table_association" "rt_ass_spoke_2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_2_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_spoke.id
}

resource "aws_ec2_transit_gateway_route_table_association" "rt_ass_onprem" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.onprem_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_spoke.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "rt_prop_egress" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_spoke.id
}

resource "aws_ec2_transit_gateway_route" "rtb_spoke_static_route" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_spoke.id
}

#################################################################################################
#Configure route table hub
resource "aws_ec2_transit_gateway_route_table_association" "rt_ass_egress" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_hub.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "rt_prop_spoke_1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_1_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_hub.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "rt_prop_spoke_2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.spoke_2_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_hub.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "rt_prop_onprem" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.onprem_tgw.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.rtb_hub.id
}







