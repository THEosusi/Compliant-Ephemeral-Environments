output "instance_id" {
  value       = aws_instance.ephemeral.id
  description = "Created EC2 instance id"
}

output "private_ip" {
  value       = aws_instance.ephemeral.private_ip
  description = "Private IP of instance (only visible inside VPC)"
}

output "public_ip" {
  value       = aws_instance.ephemeral.public_ip
  description = "Public IP of instance"
}