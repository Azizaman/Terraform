#!/bin/bash
set -e
exec > >(tee /var/log/user-data.log)
exec 2>&1

echo "================================"
echo "Starting backend setup at $(date)"
echo "================================"

# -------------------------------
# 1. CONFIGURE DB VARIABLES
# -------------------------------
# DB_ENDPOINT="project.c8dg28qmmlpa.us-east-1.rds.amazonaws.com"
# DB_USER="aman"
# DB_PASSWORD="azizaman"
# DB_NAME="react_node_app"


DB_ENDPOINT="${db_endpoint}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"
DB_TABLE_NAME="${db_table_name}"



# -------------------------------
# 2. Install Dependencies
# -------------------------------
yum update -y
yum install -y git nodejs mariadb105 
yum install httpd -y

systemctl enable httpd
systemctl start httpd

npm install -g pm2

# -------------------------------
# 3. Clone repo
# -------------------------------
su - ec2-user -c "git clone https://github.com/Azizaman/fullstack-authors-books-application.git"

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

chown ec2-user:ec2-user /home/ec2-user/fullstack-authors-books-application/backend/configs/db.js

# -------------------------------
# 5. ENV file
# -------------------------------
echo "PORT=3000" > /home/ec2-user/fullstack-authors-books-application/backend/.env
echo "HOST=0.0.0.0" >> /home/ec2-user/fullstack-authors-books-application/backend/.env
chown ec2-user:ec2-user /home/ec2-user/fullstack-authors-books-application/backend/.env

# -------------------------------
# 6. Patch server.js
# -------------------------------
sed -i '1i require("dotenv").config();' /home/ec2-user/fullstack-authors-books-application/backend/server.js

sed -i "/app.use(express.json());/a\
// Health Check\napp.get('/health', (req, res) => {\n  res.status(200).json({ status: 'healthy' });\n});" /home/ec2-user/fullstack-authors-books-application/backend/server.js

sed -i "s|app.use('/books'|app.use('/api/books'|g" /home/ec2-user/fullstack-authors-books-application/backend/server.js
sed -i "s|app.use('/authors'|app.use('/api/authors'|g" /home/ec2-user/fullstack-authors-books-application/backend/server.js


# -------------------------------
# 7. RESET DATABASE COMPLETELY
# -------------------------------
echo "Dropping existing tables..."
mysql -h "$DB_ENDPOINT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_TABLE_NAME" <<EOSQL
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;
SET FOREIGN_KEY_CHECKS = 1;
EOSQL

echo "Tables dropped."

# -------------------------------
# 8. Recreate database schema
# -------------------------------
echo "Initializing fresh database..."
mysql -h "$DB_ENDPOINT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_TABLE_NAME" < /home/ec2-user/fullstack-authors-books-application/backend/db.sql
echo "Database initialized."

# Verify
AUTHOR_COUNT=$(mysql -h "$DB_ENDPOINT" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_TABLE_NAME" -N -e "SELECT COUNT(*) FROM author;")
BOOK_COUNT=$(mysql -h "$DB_ENDPOINT" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_TABLE_NAME" -N -e "SELECT COUNT(*) FROM book;")
echo "Database now has $AUTHOR_COUNT authors and $BOOK_COUNT books"


# -------------------------------
# 9. Install & start backend
# -------------------------------
su - ec2-user -c "cd fullstack-authors-books-application/backend && npm install"
su - ec2-user -c "cd fullstack-authors-books-application/backend && npm install dotenv"

su - ec2-user -c "cd fullstack-authors-books-application/backend && pm2 start server.js --name 'backend-api'"

# Auto-start on reboot
env PATH=$PATH:/usr/bin /usr/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user
su - ec2-user -c "pm2 save"

# -------------------------------
# 10. Verify backend is running
# -------------------------------
sleep 10
if curl -f http://localhost:3000/health; then
    echo "Backend is running successfully!"
else
    echo "WARNING: Backend health check failed!"
    su - ec2-user -c "pm2 logs backend-api --lines 50"
fi

echo "================================"
echo "Backend setup completed at $(date)"
echo "================================"
