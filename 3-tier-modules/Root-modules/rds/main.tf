resource "aws_db_subnet_group" "db_subnet_group" {
    name = var.rds_subnet_group_name
    subnet_ids = var.rds_subnet_ids
    tags = {
    Name = "my-rds-subnet-group"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier = var.db_name
  engine = "mysql"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  username = var.username
  password = var.password
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [var.vpc_security_group_ids]
  publicly_accessible = false
  multi_az            = false
  tags = {
    Name = "mydb"
  }
  



    
  
}