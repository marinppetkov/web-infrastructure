provider "aws" {
  region     = "eu-central-1"
}

module vpc {
  source = "./vpc"
}

module ec2 {
  source = "./ec2"
  webhost_sg_id = module.SecurityGroups.webhost_sg_id
  pub_snet_1_id = module.vpc.pub_snet_1_id
  pub_snet_2_id = module.vpc.pub_snet_2_id
  efs_dns       = module.EFS.efs_dns
  rds_address   = module.Database.rds_address
  db_password   = var.db_password
}

module SecurityGroups {
  source = "./SG"
  vpc_id = module.vpc.vpc_id
}

module LoadBalancer {
  source = "./LB"
  vpc_id          = module.vpc.vpc_id
  alb_sg_id       = module.SecurityGroups.alb_sg_id
  pub_snet_1_id   = module.vpc.pub_snet_1_id
  pub_snet_2_id   = module.vpc.pub_snet_2_id
  web_server_1_id = module.ec2.web_server_1_id 
  web_server_2_id = module.ec2.web_server_2_id 
}

module Database {
  source = "./DB"
  rds_sg_id    = module.SecurityGroups.rds_sg_id 
  db_snet_1_id = module.vpc.db_snet_1_id
  db_snet_2_id = module.vpc.db_snet_2_id
  db_password  = var.db_password
}

module EFS {
  source = "./efs"
  efs_sg_id     = module.SecurityGroups.efs_sg_id
  pub_snet_1_id = module.vpc.pub_snet_1_id
  pub_snet_2_id = module.vpc.pub_snet_2_id
}

module CloudWatch {
  source = "./monitoring"
  cloudwatch_suffix = module.LoadBalancer.cloudwatch_suffix
}