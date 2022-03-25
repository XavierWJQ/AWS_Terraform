resource "aws_lb" "glb" {
  load_balancer_type = "gateway"
  name               = "glb"

  subnet_mapping {
    subnet_id = "${aws_subnet.private_subnets_egress_data_subnet.id}"
  }
}

resource "aws_vpc_endpoint_service" "gwlb_endpoint_service" {
  acceptance_required        = var.aws_vpc_endpoint_service
  gateway_load_balancer_arns = [aws_lb.glb.arn]
}

resource "aws_vpc_endpoint" "gwlb_endpoint" {
  service_name       = aws_vpc_endpoint_service.gwlb_endpoint_service.service_name
  subnet_ids         = ["${aws_subnet.private_subnets_egress_GWLBE_subnet.id}"]
  vpc_endpoint_type  = aws_vpc_endpoint_service.gwlb_endpoint_service.service_type
  vpc_id             = aws_vpc.vpc_egress.id
  tags = {
    Name =  "${local.name_prefix}-gwlb_endpoint"
  }
}

resource "aws_vpc_endpoint" "onprem_endpoint" {
  service_name       = aws_vpc_endpoint_service.gwlb_endpoint_service.service_name
  subnet_ids         = ["${aws_subnet.public_subnets_onprem_endpoint.id}"]
  vpc_endpoint_type  = aws_vpc_endpoint_service.gwlb_endpoint_service.service_type
  vpc_id             = aws_vpc.vpc_onprem.id
  tags = {
    Name =  "${local.name_prefix}-onprem-endpoint"
  }
}