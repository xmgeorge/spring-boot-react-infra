# # Create root level resources here...

resource "random_shuffle" "public_subnet" {
  input        = data.terraform_remote_state.vpc.outputs.public_subnets
  result_count = 1
}

data "aws_key_pair" "bastion" {
  key_name           = "codeblue"
  include_public_key = true
}

module "bastion_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.3.1"


  for_each = toset(["bastion"])

  name                        = "instance-${each.key}"
  ami                         = data.aws_ami.latest.id
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = data.aws_key_pair.bastion.key_name
  create_iam_instance_profile = true
  iam_role_description        = "IAM role for bastion EC2 instance"
  iam_role_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  instance_type          = var.instance_type
  monitoring             = var.monitoring
  vpc_security_group_ids = [module.bastion_service_sg.security_group_id]
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.public_subnets, 0)
  tags = merge(
    local.tags,
    {
      "Name" = "eks-${each.key}"
      "role" = "bastion"
    },
  )
}

module "bastion_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.project}-${var.component}-sg"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr, "0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "bastion-ssh-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Service name"
      cidr_blocks = "${data.terraform_remote_state.vpc.outputs.vpc_cidr},0.0.0.0/0"
    },
  ]


}



