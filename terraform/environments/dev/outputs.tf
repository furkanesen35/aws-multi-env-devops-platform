output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "web_security_group_id" {
  description = "Security Group ID"
  value       = module.security_group.web_security_group_id
}

output "ec2_public_ip" {
  description = "Public IP address of the deployed application server"
  value       = module.compute.public_ip
}