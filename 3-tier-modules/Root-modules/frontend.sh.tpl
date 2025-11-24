#!/bin/bash
# Example Frontend User Data
# Update and install dependencies
sudo yum update -y
sudo yum install git -y
sudo dnf install -y nodejs
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

# Clone the repository
# Note: Ensure the repository URL is correct. 'autors' might be a typo for 'authors'.
git clone https://github.com/CloudTechDevOps/fullstack-autors-books-application.git

# Navigate to the directory (matching the repo name)
cd fullstack-autors-books-application
cd frontend

# Create .env file with the backend URL
# The ${backend_url} placeholder will be replaced by Terraform's templatefile function
cat > .env <<EOF
VITE_API_URL=${backend_url}
EOF

npm install
npm run build
sudo cp -r dist/* /var/www/html/
