output "aws_instance_public_ip_onprem" {
  value = aws_instance.ec2_onprem[*].public_ip
}

output "aws_instance_private_ip_spoke1" {
  value = aws_instance.ec2_spoke1[*].private_ip
}

output "aws_instance_private_ip_spoke2" {
  value = aws_instance.ec2_spoke2[*].private_ip
}

