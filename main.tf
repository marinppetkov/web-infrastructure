provider "aws" {
  region     = "eu-central-1"
}

module vpc {
  source = "./vpc"
}

module EC2 {
  source = "./ec2"
  webhost_sg_id = module.SG.webhost_sg_id
  pub_snet_1_id = module.vpc.pub_snet_1_id
  pub_snet_2_id = module.vpc.pub_snet_2_id
}

module SecurityGroups {
  source = "./SG"
  vpc_id = module.vpc.vpc_id
}

module LoadBalancer {
  source = "./LB"
  vpc_id          = module.vpc.vpc_id
  alb_sg_id       = module.SG.alb_sg_id
  pub_snet_1_id   = module.vpc.pub_snet_1_id
  pub_snet_2_id   = module.vpc.pub_snet_2_id
  web_server_1_id = module.ec2.web_server_1_id 
  web_server_2_id = module.ec2.web_server_2_id 
}

module Database {
  source = "./DB"
  rds_sg_id    = module.SG.rds_sg_id 
  db_snet_1_id = module.vpc.db_snet_2_id
  db_snet_2_id = module.vpc.db_snet_2_id
}

module EFS {
  source = "./efs"
  efs_sg_id     = module.SG.efs_sg_id
  pub_snet_1_id = module.vpc.pub_snet_1_id
  pub_snet_2_id = module.vpc.pub_snet_2_id
}

module CloudWatch {
  source = "./monitoring"
  cloudwatch_suffix = module.LB.cloudwatch_suffix
}