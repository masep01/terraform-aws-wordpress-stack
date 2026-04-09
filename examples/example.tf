# ------------------------------------------------------------------------------
# EXAMPLE: BASIC WORDPRESS STACK DEPLOYMENT
# ------------------------------------------------------------------------------
# This example demonstrates how to deploy the WordPress stack using the 
# masep01/wordpress-stack/aws module.
# ------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  # profile = "default" # Uncomment and modify if using a specific local AWS CLI profile
}

# ------------------------------------------------------------------------------
# WORDPRESS MODULE INVOCATION
# ------------------------------------------------------------------------------
module "wordpress_stack" {
  # To use this module in your own project, pull it from the Terraform Registry:
  source  = "masep01/wordpress-stack/aws"
  version = "1.0.0"

  # NOTE: If you cloned this GitHub repository and are running this example 
  # locally, comment the two lines above and uncomment the local path below:
  # source = "../../"

  # --- Optional Variables (Overriding defaults) ---
  aws_region   = "us-east-1"
  project_name = "example-wp-deployment"

  # --- Required Network Variables ---
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  
  # --- Required Database Variables ---
  # WARNING: Hardcoding database credentials in plain text is highly discouraged 
  # for production environments. This is done here strictly for demonstration 
  # purposes. In a real-world scenario, pass these values securely using 
  # environment variables (e.g., TF_VAR_db_password) or a secrets manager.
  db_username = "wpadmin"
  db_password = "SuperS3cureP4ssw0rd123!" 
}

# ------------------------------------------------------------------------------
# EXAMPLE OUTPUTS
# ------------------------------------------------------------------------------
output "wordpress_url" {
  description = "Direct HTTP URL to access the deployed WordPress site"
  value       = module.wordpress_stack.wordpress_url
}

output "rds_endpoint" {
  description = "Connection endpoint for the RDS MySQL database"
  value       = module.wordpress_stack.rds_endpoint
}

output "redis_endpoint" {
  description = "Connection endpoint for the ElastiCache Redis cluster"
  value       = module.wordpress_stack.redis_endpoint
}