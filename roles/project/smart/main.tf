module "vpc_subnets" {
  source               = "../../../modules/vpc"
  name                 = "${var.app_name}"
  environment          = "${var.environment_name}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  vpc_cidr             = "172.16.0.0/16"
  public_subnets_cidr  = "172.16.10.0/24"
  private_subnets_cidr = "172.16.30.0/24,172.16.40.0/24"
  azs                  = "eu-west-1a,eu-west-1b"
}
