output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [
    aws_subnet.public_1.id, 
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [
    aws_subnet.private_1.id, 
    aws_subnet.private_2.id
  ]
}

output "nat_gateway_ip" {
  description = "Public IP of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "wordpress_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.wordpress_web.public_ip
}

output "wordpress_url" {
  description = "Direct URL to access your WordPress site"
  value       = "http://${aws_instance.wordpress_web.public_ip}"
}

output "rds_endpoint" {
  description = "Connection endpoint for the MySQL database"
  value       = aws_db_instance.wordpress_db.endpoint
}

output "redis_endpoint" {
  description = "Connection endpoint for the Redis cluster"
  value       = aws_elasticache_cluster.wordpress_redis.cache_nodes[0].address
}