#######################################
# Output: VPC ID
#######################################
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main.id
}

#######################################
# Output: Public Subnet IDs
#######################################
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

#######################################
# Output: Private Subnet IDs
#######################################
output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}

#######################################
# Output: ALB DNS Name
#######################################
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

#######################################
# Output: RDS Endpoint
#######################################
output "rds_endpoint" {
  description = "Endpoint of the RDS database"
  value       = aws_db_instance.main.endpoint
}