module "self_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/self-managed-node-group"

  name                = "${local.cluster_name}-node"
  cluster_name        = module.eks.cluster_name
  cluster_version     = module.eks.cluster_version
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_auth_base64 = module.eks.cluster_certificate_authority_data

  subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets

  instance_type        = "t3.large"
  min_size             = 1
  max_size             = 2
  desired_size         = 1
  launch_template_name = "${local.cluster_name}-lt"
  cluster_service_cidr = module.eks.cluster_service_cidr
  iam_role_arn         = aws_iam_role.self_node_role.arn

  vpc_security_group_ids = [
    module.eks.cluster_primary_security_group_id,
    module.eks.node_security_group_id,
  ]

  tags = local.tags 
}
