#!/bin/bash
# Update and install dependencies
sudo apt update
sudo apt install apache2 default-mysql-client php libapache2-mod-php php-mysql php-redis -y

# Restart Apache to detect PHP
sudo systemctl restart apache2

# Download and install WordPress
cd /tmp
sudo wget https://wordpress.org/latest.tar.gz
sudo tar xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/
sudo rm /var/www/html/index.html

# Configure WordPress dynamically
cd /var/www/html
sudo cp wp-config-sample.php wp-config.php

# Clean the RDS endpoint (Terraform returns endpoint:port, WP only needs the host)
DB_HOST=$(echo "${db_host}" | cut -d: -f1)

# Inject variables into wp-config.php using sed
sudo sed -i "s/database_name_here/${db_name}/g" wp-config.php
sudo sed -i "s/username_here/${db_user}/g" wp-config.php
sudo sed -i "s/password_here/${db_password}/g" wp-config.php
sudo sed -i "s/localhost/$DB_HOST/g" wp-config.php

# Add Redis cache configuration (requires Redis plugin in WP later)
sudo sed -i "/WP_DEBUG/a define('WP_REDIS_HOST', '${redis_host}');" wp-config.php

# Adjust permissions so the web server owns the files
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html