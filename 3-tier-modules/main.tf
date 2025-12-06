module "network" {
  source = "./Root-modules/network"

  vpc_cidr                    = var.vpc_cidr
  public_subnet_cidrs         = var.public_subnet_cidrs
  availability_zones          = var.availability_zones
  vpc_name                    = var.vpc_name
  frontend_private_subnet_cidrs = var.frontend_private_subnet_cidrs
  backend_private_subnet_cidrs  = var.backend_private_subnet_cidrs
  database_private_subnet_cidrs = var.database_private_subnet_cidrs
}

module "security" {
  source = "./Root-modules/security"

  vpc_id = module.network.vpc_id
  ssh_port = var.ssh_port
  http_port = var.http_port
  https_port = var.https_port
}

module "instance" {
  source = "./Root-modules/instance"

  vpc_name              = var.vpc_name
  bastion_instance_type = var.bastion_instance_type
  bastian_ami           = data.aws_ami.amazon_linux_2023.id
  bastion_sg_id         = module.security.public_sg_id
  bastion_key_name      = var.key_name
  bastian_subnet_id     = module.network.public_subnet_ids[0]
}

module "rds" {
  source = "./Root-modules/rds"

  rds_subnet_group_name  = var.rds_subnet_group_name
  rds_subnet_ids         = module.network.database_private_subnet_ids
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = module.security.database_sg_id
}

module "alb" {
  source = "./Root-modules/alb"

  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.backend_private_subnet_ids
  public_sg_id        = module.security.public_sg_id
  backend_sg_id       = module.security.backend_sg_id
  frontend_tg_name    = var.frontend_tg_name
  frontend_tg_port    = var.frontend_tg_port
  frontend_alb_name   = var.frontend_alb_name
  backend_tg_name     = var.backend_tg_name
  backend_tg_port     = var.backend_tg_port
  backend_alb_name    = var.backend_alb_name
  certificate_arn = var.certificate_arn
  
}

module "asg" {
  source = "./Root-modules/asg"

  vpc_name                = var.vpc_name
  key_name                = var.key_name
  
  frontend_ami            = data.aws_ami.amazon_linux_2023.id
  frontend_instance_type  = var.frontend_instance_type
  frontend_sg_id          = module.security.frontend_sg_id
  frontend_subnet_ids     = module.network.frontend_private_subnet_ids
  frontend_user_data      = templatefile(var.frontend_user_data, {
    backend_url = "https://api.${var.domain_name}/api"
  })
  frontend_target_group_arn = module.alb.frontend_target_group_arn

  backend_ami             = data.aws_ami.amazon_linux_2023.id
  backend_instance_type   = var.backend_instance_type
  backend_sg_id           = module.security.backend_sg_id
  backend_subnet_ids      = module.network.backend_private_subnet_ids
  backend_user_data       = templatefile(var.backend_user_data, {
    db_endpoint = module.rds.db_instance_endpoint
    db_user     = var.db_username
    db_password = var.db_password
    db_table_name     = var.db_table_name
  })
  backend_target_group_arn = module.alb.backend_target_group_arn
  iam_instance_profile_name = module.iam.instance_profile_name
}

module "route53" {
  source               = "./Root-modules/route53"

  hosted_zone_id       = var.hosted_zone_id
  domain_name          = var.domain_name
  
  backend_alb_dns      = module.alb.backend_alb_dns_name
  backend_alb_zone_id  = module.alb.backend_alb_zone_id
  
  frontend_alb_dns     = module.alb.frontend_alb_dns_name
  frontend_alb_zone_id = module.alb.frontend_alb_zone_id
}

module "s3" {
  source = "./Root-modules/s3"

  project_name = var.project_name
  

  
}

module "iam" {
  source = "./Root-modules/iam"

  iam_role_name = var.iam_role_name
  # instance_profile_name = var.instance_profile_name
  s3_access_role_name = var.s3_access_role_name
  s3_access_instance_profile_name = var.s3_access_instance_profile_name
  lambda_s3_ec2_access_role_name = var.lambda_s3_ec2_access_role_name
  lambda_s3_ec2_access_instance_profile_name=var.lambda_s3_ec2_access_instance_profile_name
  log_archive_bucket_arn = module.s3.log_archive_bucket_arn
  

}


