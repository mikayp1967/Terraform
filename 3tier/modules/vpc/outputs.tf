output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${element(concat(aws_vpc.vpc_module.*.id, list("")), 0)}"
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = "${element(concat(aws_vpc.vpc_module.*.arn, list("")), 0)}"
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = "${element(concat(aws_vpc.vpc_module.*.default_security_group_id, list("")), 0)}"
}


