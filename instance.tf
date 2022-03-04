data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_instance" "ec2_spoke1" {
    ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
    availability_zone      = var.aws_availability_zones
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.private_subnets_spoke1.id
    vpc_security_group_ids = [aws_default_security_group.spoke_1.id]
    key_name = "key-jq"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.vpc_spoke1,"name")}-instance}"
    }
}

resource "aws_instance" "ec2_spoke2" {
    ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
    availability_zone      = var.aws_availability_zones
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.private_subnets_spoke2.id
    vpc_security_group_ids = [aws_default_security_group.spoke_2.id]
    key_name = "key-jq"
    tags                   = {
        Name = "${local.name_prefix}-${lookup(var.vpc_spoke2,"name")}-instance"
    }
}

resource "aws_instance" "ec2_onprem" {
    ami                         = nonsensitive(data.aws_ssm_parameter.ami.value)
    availability_zone           = var.aws_availability_zones
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.public_subnets_onprem.id
    vpc_security_group_ids      = [aws_default_security_group.onprem.id]
    associate_public_ip_address = true
    key_name = "key-jq"
    tags                        = {
        Name = "${local.name_prefix}-${lookup(var.vpc_onprem,"name")}-instance"
    }
}