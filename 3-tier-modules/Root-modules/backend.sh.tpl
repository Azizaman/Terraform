#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "================================"
echo "Starting backend setup at $(date)"
echo "================================"


# -------------------------------
# 1. DB VARIABLES FROM TERRAFORM
# -------------------------------
DB_ENDPOINT="${db_endpoint}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"
DB_TABLE_NAME="${db_table_name}"


# -------------------------------
# 2. Install Dependencies
# -------------------------------
yum update -y
yum install -y git mariadb105 httpd amazon-cloudwatch-agent
dnf install -y nodejs
npm install -g pm2

systemctl enable httpd
systemctl start httpd


# -------------------------------
# 3. Clone Repository
# -------------------------------
cd /home/ec2-user
git clone https://github.com/Azizaman/fullstack-authors-books-application.git
chown -R ec2-user:ec2-user /home/ec2-user/fullstack-authors-books-application


# -------------------------------
# 4. Create DB config
# -------------------------------
cat > /home/ec2-user/fullstack-authors-books-application/backend/configs/db.js <<EOF
const mysql = require('mysql2');
const db = mysql.createConnection({
  host: '${db_endpoint}',
  port: '3306',
  user: '${db_user}',
  password: '${db_password}',
  database: '${db_table_name}'
});
module.exports = db;
EOF


# -------------------------------
# 5. ENV file
# -------------------------------
cat > /home/ec2-user/fullstack-authors-books-application/backend/.env <<EOF
PORT=3000
HOST=0.0.0.0
EOF


# -------------------------------
# 6. Patch server.js
# -------------------------------
sed -i '1i require("dotenv").config();' /home/ec2-user/fullstack-authors-books-application/backend/server.js

sed -i "/app.use(express.json());/a\
// Health Check\napp.get('/health', (req, res) => {\n  res.status(200).json({ status: 'healthy' });\n});" \
  /home/ec2-user/fullstack-authors-books-application/backend/server.js

sed -i "s|app.use('/books'|app.use('/api/books'|g" /home/ec2-user/fullstack-authors-books-application/backend/server.js
sed -i "s|app.use('/authors'|app.use('/api/authors'|g" /home/ec2-user/fullstack-authors-books-application/backend/server.js


# -------------------------------
# 7. RESET DATABASE
# -------------------------------
echo "Dropping existing tables..."
mysql -h "$DB_ENDPOINT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_TABLE_NAME" <<EOSQL
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;
SET FOREIGN_KEY_CHECKS = 1;
EOSQL

# Initialize DB
mysql -h "$DB_ENDPOINT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_TABLE_NAME" \
  < /home/ec2-user/fullstack-authors-books-application/backend/db.sql


# -------------------------------
# 8. Install & Start Backend
# -------------------------------
su - ec2-user -c "cd fullstack-authors-books-application/backend && npm install && npm install dotenv"
su - ec2-user -c "cd fullstack-authors-books-application/backend && pm2 start server.js --name 'backend-api'"
su - ec2-user -c "pm2 save"

# Auto-start PM2 on reboot
env PATH=$PATH:/usr/bin /usr/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user


# -------------------------------
# 9. Configure CloudWatch (AFTER PM2 STARTS)
# -------------------------------
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ec2-user/.pm2/logs/backend-api-out.log",
            "log_group_name": "/backend/app",
            "log_stream_name": "{instance_id}-out"
          },
          {
            "file_path": "/home/ec2-user/.pm2/logs/backend-api-error.log",
            "log_group_name": "/backend/app",
            "log_stream_name": "{instance_id}-error"
          }
        ]
      }
    }
  }
}
EOF

systemctl enable amazon-cloudwatch-agent
systemctl restart amazon-cloudwatch-agent


# -------------------------------
# 10. Verify Backend
# -------------------------------
sleep 5
curl -f http://localhost:3000/health && echo "Backend Healthy!"

echo "================================"
echo "Backend setup completed!"
echo "================================"
