# ---------------------------------------------
# 1. SECURITY AND NETWORKING FOR DATABASES
# ---------------------------------------------
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id] 
  
  tags = { Name = "${var.project_name}-db-subnet-group" }
}

# MYSQL DATABASE SECURITY GROUP
resource "aws_security_group" "mysql_db_sg" {
  name        = "${var.project_name}-mysql-db-sg"
  description = "Allow MySQL access from the web server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = { Name = "${var.project_name}-mysql-db-sg" }
}

# REDIS CACHE SECURITY GROUP
resource "aws_security_group" "redis_cache_sg" {
  name        = "${var.project_name}-redis-cache-sg"
  description = "Allow Redis access from the web server"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = { Name = "${var.project_name}-redis-cache-sg" }
}

# ---------------------------------------------
# 2. RDS INSTANCE (MySQL)
# ---------------------------------------------
resource "aws_db_instance" "wordpress_db" {
  identifier             = "${var.project_name}-rds"
  
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro" 
  db_name                = "wordpressdb"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true 
  vpc_security_group_ids = [aws_security_group.mysql_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  multi_az               = false 
}

# ---------------------------------------------
# 3. ELASTICACHE INSTANCE (Redis)
# ---------------------------------------------
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.project_name}-redis-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_elasticache_cluster" "wordpress_redis" {
  cluster_id           = "wordpress-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                   = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_cache_sg.id]
}