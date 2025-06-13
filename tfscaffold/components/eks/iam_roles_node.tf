resource "aws_iam_role" "self_node_role" {
  name = "${local.cluster_name}-self-node-role"

  assume_role_policy = data.aws_iam_policy_document.node_assume_role_policy.json
}

data "aws_iam_policy_document" "node_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "self_node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.self_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "self_node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.self_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "self_node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.self_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}
