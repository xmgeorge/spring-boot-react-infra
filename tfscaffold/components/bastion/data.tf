data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.state_account}-${var.region}"
    key    = "${var.project}/${var.state_account}/${var.region}/${var.environment}/vpc/vpc.tfstate"
    region = var.region
  }
}

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["bastion-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}




