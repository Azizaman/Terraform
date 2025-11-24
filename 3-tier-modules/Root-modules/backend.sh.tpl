#!/bin/bash
# Use strict mode for better error handling
set -e

# 1. Install Dependencies (as root)
dnf update -y
dnf install -y git nodejs mariadb105 httpd

# Enable and start httpd
systemctl enable httpd
systemctl start httpd

# Install PM2 globally
npm install -g pm2

# 2. Setup Application Directory (as ec2-user)
su - ec2-user -c "git clone https://github.com/Azizaman/fullstack-authors-books-application.git"

# 3. Configure Database Connection
cat > /home/ec2-user/fullstack-authors-books-application/backend/configs/db.js <<EOF
const mysql = require('mysql2');
const db = mysql.createConnection({
  host: '${db_endpoint}',
  port: '3306',
  user: '${db_user}',
  password: '${db_password}',
  database: '${db_name}'
});
module.exports = db;
EOF

# Fix ownership
chown ec2-user:ec2-user /home/ec2-user/fullstack-authors-books-application/backend/configs/db.js

# -------------------------------
# ✅ ADDING .env with PORT=3000
# -------------------------------

echo "PORT=3000" > /home/ec2-user/fullstack-authors-books-application/backend/.env
echo "HOST=0.0.0.0" >> /home/ec2-user/fullstack-authors-books-application/backend/.env
chown ec2-user:ec2-user /home/ec2-user/fullstack-authors-books-application/backend/.env


# -------------------------------
# ✅ Patch server.js to load .env
# -------------------------------
sed -i '1i require("dotenv").config();' /home/ec2-user/fullstack-authors-books-application/backend/server.js
sed -i "/app.use(express.json());/a\n\n// Health check endpoints\napp.get('/api', (req, res) => {\n    res.status(200).json({ status: 'ok', message: 'API is running' });\n});\n\napp.get('/health', (req, res) => {\n    res.status(200).json({\n        status: 'healthy',\n        service: 'backend-api',\n        uptime: process.uptime(),\n        timestamp: new Date().toISOString()\n    });\n});" /home/ec2-user/fullstack-authors-books-application/backend/server.js

# Change /books routes to /api/books
sed -i "s|app.use('/books'|app.use('/api/books'|g" /home/ec2-user/fullstack-authors-books-application/backend/server.js

# If there are other routes, update them too
sed -i "s|app.use('/authors'|app.use('/api/authors'|g" /home/ec2-user/fullstack-authors-books-application/backend/server.js

# 5. Start Application (as ec2-user)
su - ec2-user -c "cd fullstack-authors-books-application/backend && npm install"
su - ec2-user -c "cd fullstack-authors-books-application/backend && npm install dotenv"
su - ec2-user -c "cd fullstack-authors-books-application/backend && pm2 start server.js --name 'veera'"

# 6. Configure PM2 to start on boot
env PATH=$PATH:/usr/bin /usr/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user
su - ec2-user -c "pm2 save"
