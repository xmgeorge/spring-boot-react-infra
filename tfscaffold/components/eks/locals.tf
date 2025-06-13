data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_name
}

data "aws_caller_identity" "current" {}



locals {
  tags = merge(
    var.default_tags,
    var.env_tags,
    {
      "environment" = var.environment
      "component"   = var.component
    },
  )
  coredns_config = {
    replicaCount = 1
  }

  cluster_name              = "${var.project}-${var.environment}-eks"
  cluster_enabled_log_types = ["api", "audit", "authenticator"]

}

