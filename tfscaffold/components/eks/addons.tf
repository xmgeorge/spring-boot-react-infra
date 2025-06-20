module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" #ensure to update this to the latest/desired version

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    coredns = {
      most_recent = true
      configuration_values = jsonencode({
        replicaCount = 1
      })
    }
    vpc-cni = {
      most_recent = true
      # pod_identity_association = {
      #   role_arn = aws_iam_role.vpc_cni.arn
      # }
      service_account_role_arn = aws_iam_role.vpc_cni.arn

    }
    kube-proxy = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller = true

  aws_load_balancer_controller = {
    service_account_annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
    }
  }

  enable_external_dns = false
  enable_cert_manager = false

  #   external_dns = {
  #   name          = "external-dns"
  #   chart_version = "1.12.2"
  #   repository    = "https://kubernetes-sigs.github.io/external-dns/"
  #   namespace     = "external-dns"

  #   values = [yamlencode({
  #     args = [
  #       "--source=ingress",
  #       "--domain-filter=georgeulahannan.live",
  #       "--provider=aws",
  #       "--registry=txt",
  #       "--txt-owner-id=george-cluster",
  #       "--txt-prefix=external-dns-",
  #       "--interval=1m"
  #     ]
  #   })]
  # }
  # external_dns_route53_zone_arns = [data.terraform_remote_state.acm.outputs.zone_arn]

  tags = local.tags
}

#Role for vpc cni
resource "aws_iam_role" "vpc_cni" {
  name = "${local.cluster_name}-vpc-cni"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = module.eks.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-node"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_cni" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}


resource "aws_iam_role_policy_attachment" "vpc_cni_ec2" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "vpc_cni_networking" {
  role       = aws_iam_role.vpc_cni.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}


data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${module.eks.oidc_provider}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "aws-load-balancer-controller"
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json
}

resource "aws_iam_policy" "alb_controller_policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("${path.module}/alb-iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}