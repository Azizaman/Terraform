#!/bin/bash

# Update system
yum update -y

# Install packages
yum install -y git httpd amazon-cloudwatch-agent
dnf install -y nodejs

# Start & enable Apache
systemctl enable httpd
systemctl start httpd

# Create CloudWatch Agent config
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/httpd/error_log",
            "log_group_name": "/frontend/app",
            "log_stream_name": "{instance_id}-error",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          },
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "/frontend/app",
            "log_stream_name": "{instance_id}-access",
            "timestamp_format": "%Y-%m-%d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch agent
systemctl enable amazon-cloudwatch-agent
systemctl restart amazon-cloudwatch-agent

# Clone your repo
cd /home/ec2-user
git clone https://github.com/CloudTechDevOps/fullstack-autors-books-application.git

cd fullstack-autors-books-application/frontend

# Create ENV file dynamically from Terraform
echo "VITE_API_URL=${backend_url}" > .env

# Build frontend
npm install
npm run build

# Deploy build to Apache root
cp -r dist/* /var/www/html/

# Ensure correct permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
