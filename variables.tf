variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Base name to tag the resources"
  type        = string
  default     = "wordpress"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "db_username" {
  description = "Administrator username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database (minimum 8 characters)"
  type        = string
  sensitive   = true
}