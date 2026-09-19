output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.app_server.id
}

output "public_ip" {
  description = "Public IP of EC2 Instance"
  value       = aws_instance.app_server.public_ip
}