#Create Security_group
#Change setups for default sg
resource "aws_default_security_group" "spoke_1" {
    vpc_id = aws_vpc.vpc_spoke1.id
    ingress {
        description = "allow all traffic with protocol http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol https"        
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol icmp"
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_default_security_group" "spoke_2" {
    vpc_id = aws_vpc.vpc_spoke2.id
    ingress {
        description = "allow all traffic with protocol http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol https"        
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol icmp"
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_default_security_group" "onprem" {
    vpc_id = aws_vpc.vpc_onprem.id
    ingress {
        description = "allow all traffic with protocol http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol https"        
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol icmp"
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_default_security_group" "Egress" {
    vpc_id = aws_vpc.vpc_egress.id
    ingress {
        description = "allow all traffic with protocol http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol https"        
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "allow all traffic with protocol icmp"
        from_port   = -1
        to_port     = -1
        protocol    = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#Create SG for subnet mgmt+tgw
resource "aws_security_group" "SG_mgmt_tgw" {
    name =  "SG-mgmt-tgw-egress"
    vpc_id = aws_vpc.vpc_egress.id
    ingress {
        description = "allow traffic from onprem subnet with protocol http"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["192.168.10.0/26"]
    }
    ingress {
        description = "allow traffic from onprem subnet with protocol https"        
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["192.168.10.0/26"]
    }
    ingress {
        description = "allow traffic from onprem subnet with protocol ssh"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["192.168.10.0/26"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "SG-mgmt-tgw"
    }
}

#Create SG for data
resource "aws_security_group" "SG_data" {
  name =  "SG-data-egress"
  vpc_id = aws_vpc.vpc_egress.id
    ingress {
        description = "GENEVE"
        from_port   = 6081
        to_port     = 6081
        protocol    = "udp"
        cidr_blocks = "${aws_vpc_endpoint.gwlb_endpoint.cidr_blocks}"
    }
    ingress {
        description = "allow traffic from health check of tg with protocol tcp"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "SG-data"
    }
}

