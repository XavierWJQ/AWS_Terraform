
variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "aws_availability_zones" {
    type = string
    default = "us-east-1a"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}


variable  "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = false
}


variable "vpc_spoke1" {
    type = map
    default = {
        name = "vpc-spoke-1"
        cidr = "192.168.3.0/24"
    }
}

variable "vpc_spoke2" {
    type = map
    default = {
        name = "vpc-spoke-2"
        cidr = "192.168.4.0/24"
    }
}

variable "vpc_onprem" {
    type = map
    default = {
        name = "vpc-onprem"
        cidr = "192.168.10.0/24"
    }
}

variable "vpc_egress" {
    type = map
    default = {
        name = "vpc-egress"
        cidr = "192.168.2.0/24"
    }
}

variable "private_subnets_spoke1" {
    type = map
    default = {
        name = "private-subnet-spoke-1"
        cidr = "192.168.3.0/26"
    }
}

variable "public_subnets_spoke1" {
    type = map
    default = {
        name = "private-subnet-spoke-1"
        cidr = "192.168.3.64/28"
    }
}

variable "private_subnets_spoke2" {
    type         = map
    default      = {
            name = "private-subnet-spoke-2"
            cidr = "192.168.4.0/26"
    }
}

variable "public_subnets_onprem" {
    type         = map
    default      = {
            name = "private-subnet-onprem-1"
            cidr = "192.168.10.0/26"
    }
}

variable "public_subnets_onprem_endpoint" {
    type         = map
    default      = {
            name = "public-subnet-onprem-endpoint"
            cidr = "192.168.10.64/28"
    }
}

variable "private_subnets_egress_mgmt_tgw" {
    type                    = map
    default                 = {
            name = "mgmt-tgw-subnet"
            cidr = "192.168.2.32/27"
    }
}

variable "private_subnets_egress_data_subnet" {
    type                    = map
    default                 = {
            name = "data-subnet"
            cidr = "192.168.2.0/27"
    }
}


variable "private_subnets_egress_GWLBE_subnet" {
    type                    = map
    default                 = {
            name = "GWLBE-subnet"
            cidr = "192.168.2.64/28"
    }
}

variable "public_subnets_egress_NATGW_subnet"{
    type = map
    default = {
            name = "NATGW-subnet"
            cidr = "192.168.2.80/28"
    }
}

variable "instance_type" {
    type = string
    default = "t2.micro"
  
}

variable "instance_type_fortigate" {
    type = string
    default = "t2.small"
}

variable "image_instance" {
    type = string
    default = "ami-0c293f3f676ec4f90"
}

variable "image_fortigate" {
    type = string
    default = "ami-03e7e7d91a52ca5a8"
}

variable "eth0_fortigate" {
    type = string
    default = "192.168.2.93"
}

variable "eip_eth0_fortigate" {
    type = string
    default = "50.16.29.214"
}

variable "eth1_fortigate" {
    type = string
    default = "192.168.2.18"
}

variable "eip_eth1_fortigate" {
    type = string
    default = "52.4.110.136"
}

variable "eth0_spoke1" {
    type = string
    default = "192.168.3.23"
}

variable "default_route_table_association" {
    type = string
    default = "disable"
}

variable "default_route_table_propagation" {
    type = string
    default = "disable"
}

variable "aws_vpc_endpoint_service" {
    type = bool
    default = false
}

variable "pipeline_repo_name" {
    description = "pipeline repo name"
    type = string
    default = "buildingbloc_pipeline_repo"
}

variable "source_repo_branch" {
    description = "Source repo branch"
    type = string
    default = "main"
}

variable "pipeline_project" {
    type = string
    default = "pipeline"
}

variable "dockerhub_credentials" {
    type = string
    default = "arn:aws:secretsmanager:us-east-1:492696539201:secret:codebuild/dockerhub-0OHIcg"
}

variable "codestar_credentials" {
    type = string
    default = "arn:aws:codestar-connections:us-east-1:492696539201:connection/51f3c91e-2045-49c6-abd4-8938495450d4"
}
