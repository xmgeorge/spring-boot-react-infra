module "eks" {
  source                                 = "terraform-aws-modules/eks/aws"
  version                                = "20.13.1"
  cluster_name                           = local.cluster_name
  cluster_version                        = var.cluster_version
  cluster_enabled_log_types              = local.cluster_enabled_log_types
  cloudwatch_log_group_retention_in_days = 7
  cluster_endpoint_public_access         = true
  cluster_endpoint_public_access_cidrs   = var.cluster_public_access_cidrs
  cluster_service_ipv4_cidr              = var.cluster_service_ipv4_cidr

  #create_kms_key = false

  cluster_ip_family             = "ipv4"
#   kms_key_enable_default_policy = false
  enable_irsa                   = true

  enable_cluster_creator_admin_permissions = true



access_entries = merge(
  {
    for entry in local.eks_access_entries : entry.username => {
      principal_arn = entry.username
      policy_associations = {
        single = {
          policy_arn = entry.access_policy
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  },
  {
    self_node_group = {
      principal_arn = aws_iam_role.self_node_role.arn
      # Optional: kubernetes_groups = ["system:bootstrappers", "system:nodes"]
    }
  }
)



  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets

  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["t3.medium"]

      iam_role_arn = aws_iam_role.self_node_role.arn

      iam_role_additional_policies = {
        ssm_access        = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        cloudwatch_access = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
        service_role_ssm  = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
        default_policy    = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
      }

      subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets
    }
  }



  tags = local.tags
}


locals {
  eks_access_policy = {
    viewer = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
    admin  = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  }

  eks_access_list = {
    viewer = {
      user_arn = []
    }
    admin = {
      user_arn = ["arn:aws:iam::774305572856:root"]
    }
  }

  eks_access_entries = flatten([
    for group, config in local.eks_access_list : [
      for arn in config.user_arn : {
        username       = arn
        access_policy  = lookup(local.eks_access_policy, group, null)
        access_type    = group
      }
    ]
  ])
}
