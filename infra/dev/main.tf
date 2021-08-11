module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "timeoff-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true 

  //Required for VPC endpoints
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags                 = local.tags
}

module myip {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = "timeoff.camilocontreras.net"
  zone_id     = "Z054282812IXC0XXVE3J8"

  tags = local.tags
}


module "timeoff" {
  source                   = "../modules/ecs/"
  name_prefix              = "timeoff"
  vpc_id                   = module.vpc.vpc_id
  timeoff_subnet_ids       = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  alb_subnet_ids           = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  alb_ingress_allow_cidrs  = ["${module.myip.address}/32"]
  alb_acm_certificate_arn  = module.acm.this_acm_certificate_arn
  timeoff_cpu              = 256
  timeoff_memory           = 512
  alb_access_logs_bucket_name = "timeoff-alb-logs"
  alb_access_logs_s3_prefix = "timeoff"
  region                   = local.region
  account_id               = local.account_id
  tags                     = local.tags
}
