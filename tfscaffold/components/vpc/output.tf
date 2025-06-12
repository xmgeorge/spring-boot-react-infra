output "vpc_id" {
  description = "VPC Id"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = module.vpc.vpc_cidr_block
}

output "vpc_name" {
  description = "VPC Name"
  value       = module.vpc.name
}

output "public_subnets" {
  description = "VPC Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "VPC Private Subnet IDs"
  value       = module.vpc.private_subnets
}

output "vpc_default_security_group" {
  value       = module.vpc.default_security_group_id
  description = "AWS default_security_group"
}

output "private_subnets_cidr_blocks" {
  description = "VPC private subnetsccidr blocks"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets_cidr_blocks" {
  description = "VPC public subnets cidr blocks"
  value       = module.vpc.public_subnets_cidr_blocks
}