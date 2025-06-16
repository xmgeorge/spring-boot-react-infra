# Define variable values to be fed into components in the components directory that will each form a part of the examplenv environment...
environment                     = "prod"
scaffold_environment            = "prod_eks"
instance_type                   = "t3.medium"
cluster_version                 = "1.32"
cluster_endpoint_public_access  = true
cluster_endpoint_private_access = false
cluster_service_ipv4_cidr       = "172.20.0.0/16"
cluster_public_access_cidrs     = ["0.0.0.0/0"]
# ec2_ssh_key = "codeblue"