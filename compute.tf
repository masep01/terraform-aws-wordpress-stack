# 1. AUTOMATICALLY GET THE LATEST UBUNTU IMAGE
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. WEB SERVER SECURITY GROUP
resource "aws_security_group" "web_server_sg" {
  name        = "${var.project_name}-web-server-sg"
  description = "Allow SSH and HTTP to the web server"
  vpc_id      = aws_vpc.main.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = { Name = "${var.project_name}-web-server-sg" }
}

# 3. EC2 INSTANCE
resource "aws_instance" "wordpress_web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro" 
  subnet_id              = aws_subnet.public_1.id
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]

  # Inject into the WordPress installation script with the required parameters
  user_data = templatefile("${path.module}/install_wordpress.sh.tpl", {
    db_host     = aws_db_instance.wordpress_db.endpoint
    db_name     = aws_db_instance.wordpress_db.db_name
    db_user     = aws_db_instance.wordpress_db.username
    db_password = aws_db_instance.wordpress_db.password
    redis_host  = aws_elasticache_cluster.wordpress_redis.cache_nodes[0].address
  })

  tags = { Name = "${var.project_name}-wordpress-ec2" }
}