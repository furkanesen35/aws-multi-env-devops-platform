module "vpc" {
  source      = "../../modules/vpc"
  environment = "staging"
  project     = "aws-multi-env-devops-platform"
}

module "security_group" {
  source      = "../../modules/security-group"
  environment = "staging"
  project     = "aws-multi-env-devops-platform"
  vpc_id      = module.vpc.vpc_id
}

module "compute" {
  source            = "../../modules/compute"
  environment       = "staging"
  project           = "aws-multi-env-devops-platform"
  subnet_id         = module.vpc.public_subnet_id
  security_group_id = module.security_group.web_security_group_id
  instance_type     = "t3.micro"
}