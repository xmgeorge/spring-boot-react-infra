# Define variable values to be fed into components in the components directory that will each form a part of the examplenv environment...
environment             = "dev"
scaffold_environment    = "dev_vpc"
cidr                    = "10.0.0.0/16"
enable_nat_gateway      = false
single_nat_gateway      = false
enable_vpn_gateway      = false
one_nat_gateway_per_az  = false
map_public_ip_on_launch = true