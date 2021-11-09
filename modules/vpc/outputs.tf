output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.vpc_module.*.id, [""])[0]
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = concat(aws_vpc.vpc_module.*.arn, [""])[0]
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = concat(aws_vpc.vpc_module.*.default_security_group_id, [""])[0]
}

output "subnets" {
  description = "List of subnet IDs"
  value       = aws_subnet.subnets.*.id
}
