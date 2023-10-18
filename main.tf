provider "aws" {
  region     = "eu-central-1"
}

module vpc {
  source = "./vpc"
}

module EC2 {
  source = "./ec2"
}

module SecurityGroups {
  source = "./SG"
}

module LoadBalancer {
  source = "./LB"
}

module Database {
  source = "./DB"
}

module EFS {
  source = "./efs"
}

module CloudWatch {
  source - "./monitoring"
}