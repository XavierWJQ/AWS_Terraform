resource "aws_network_interface" "eth0_spoke1" {
  description       = "active-port0"
  subnet_id         = aws_subnet.private_subnets_spoke1.id
  private_ips       = [var.eth0_spoke1]
  security_groups    = [aws_default_security_group.spoke_1.id]
  source_dest_check = true
}

resource "aws_instance" "ec2_spoke1" {
    ami                    = var.image_instance
    availability_zone      = var.aws_availability_zones
    instance_type          = var.instance_type
    iam_instance_profile = "arn:aws:iam::492696539201:instance-profile/EC2+SSM"
    key_name = "key-jq"
    network_interface {
    network_interface_id = aws_network_interface.eth0_spoke1.id
    device_index         = 0
    }
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.vpc_spoke1,"name")}-instance}"
    }
}

resource "aws_instance" "ec2_spoke2" {
    ami                    = var.image_instance
    availability_zone      = var.aws_availability_zones
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.private_subnets_spoke2.id
    vpc_security_group_ids = [aws_default_security_group.spoke_2.id]
    iam_instance_profile = "arn:aws:iam::492696539201:instance-profile/EC2+SSM"    
    key_name = "key-jq"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.vpc_spoke2,"name")}-instance"
    }
}

resource "aws_instance" "ec2_onprem" {
    ami                         = var.image_instance
    availability_zone           = var.aws_availability_zones
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.public_subnets_onprem.id
    vpc_security_group_ids      = [aws_default_security_group.onprem.id]
    iam_instance_profile = "arn:aws:iam::492696539201:instance-profile/EC2+SSM"    
    key_name = "key-jq"
    tags                        = {
        Name = "${local.name_prefix}-${lookup(var.vpc_onprem,"name")}-instance"
    }
}


resource "aws_network_interface" "eth0_fortigate" {
  description = "active-port1"
  subnet_id   = aws_subnet.public_subnets_egress_NATGW_subnet.id
  private_ips = [var.eth0_fortigate]
  security_groups    = [aws_default_security_group.Egress.id]
  source_dest_check = false
  tags = {
    Name = "Forti-FW-1-NATGW-Public"
  }
}

resource "aws_network_interface" "eth1_fortigate" {
  description       = "active-port2"
  subnet_id         = aws_subnet.private_subnets_egress_data_subnet.id
  private_ips       = [var.eth1_fortigate]
  security_groups    = [aws_default_security_group.Egress.id]
  source_dest_check = false
  tags = {
    Name = "Forti-FW-1-data-Priv"
  }
}

resource "aws_instance" "ec2_fortigate" {
    ami                         = var.image_fortigate
    availability_zone           = var.aws_availability_zones
    instance_type               = var.instance_type_fortigate
    iam_instance_profile        = "arn:aws:iam::492696539201:instance-profile/EC2+SSM"
    depends_on                  = [aws_network_interface.eth0_fortigate, aws_network_interface.eth0_fortigate]
    network_interface {
    network_interface_id        = aws_network_interface.eth0_fortigate.id
    device_index                = 0
    }
    network_interface {
    network_interface_id        = aws_network_interface.eth1_fortigate.id
    device_index                = 1
    }
    key_name                    = "key-jq"
    tags                        = {
        Name = "${local.name_prefix}-${lookup(var.vpc_egress,"name")}-fortigate"
    }
}




