module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name                 = "${var.project}_${var.environment}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  cidr                 = var.cidr

  azs = local.azs
  # private_subnets = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
  # public_subnets  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  private_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 48)]


  enable_nat_gateway      = false
  single_nat_gateway      = false
  enable_vpn_gateway      = false
  one_nat_gateway_per_az  = false
  map_public_ip_on_launch = true

  # Adding tags to public subnets
  public_subnet_tags = {
    "Name"                                    = "Public_Subnet_${local.vpc_name}"
    "Type"                                    = "Public_Subnets"
    "kubernetes.io/role/elb"                  = 1
    "kubernetes.io/cluster/${local.vpc_name}" = "shared"


  }

  # Adding tags to private subnets
  private_subnet_tags = {
    "Name"                                    = "Private_Subnet_${local.vpc_name}"
    "Type"                                    = "Private Subnets"
    "kubernetes.io/role/internal-elb"         = 1
    "kubernetes.io/cluster/${local.vpc_name}" = "shared"

  }

  public_route_table_tags = {
    "Name" = "public-route-table-${local.vpc_name}"
    "Type" = "public_route_table_tags"

  }

  private_route_table_tags = {
    "Name" = "private-route-table-${local.vpc_name}"
    "Type" = "private_route_table_tags"
  }

  tags = merge(
    local.tags,
    {
      "Name" = local.vpc_name
    },
  )
}