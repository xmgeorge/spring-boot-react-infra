resource "helm_release" "metrics_server_release" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version = "3.12.2"

  namespace  = "kube-system"
}


# Load EBS CSI managed policy
data "aws_iam_policy" "ebs_csi" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# Create IAM Role for EBS CSI Driver
resource "aws_iam_role" "ebs_csi_role" {
  name = "ebs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = data.terraform_remote_state.eks.outputs.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${data.terraform_remote_state.eks.outputs.oidc_provider}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })
}

# Attach AmazonEBSCSIDriverPolicy to the role
resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  role       = aws_iam_role.ebs_csi_role.name
  policy_arn = data.aws_iam_policy.ebs_csi.arn
}

# Install EBS CSI driver using Helm
resource "helm_release" "ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = "2.30.0" # Optional: set stable version

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.ebs_csi_role.arn
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "ebs-csi-controller-sa"
  }

  set {
    name  = "storageClasses[0].name"
    value = "ebs-sc"
  }

  set {
    name  = "storageClasses[0].volumeBindingMode"
    value = "WaitForFirstConsumer"
  }

  set {
    name  = "storageClasses[0].reclaimPolicy"
    value = "Delete"
  }

  set {
    name  = "storageClasses[0].parameters.type"
    value = "gp3"
  }

  set {
    name  = "storageClasses[0].allowVolumeExpansion"
    value = "true"
  }

  set {
    name  = "enableVolumeScheduling"
    value = "true"
  }

  set {
    name  = "enableVolumeResizing"
    value = "true"
  }

  set {
    name  = "enableVolumeSnapshot"
    value = "true"
  }
}

output "ebs_csi_iam_role_arn" {
  value = aws_iam_role.ebs_csi_role.arn
}
