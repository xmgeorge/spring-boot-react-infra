data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.state_account}-${var.region}"
    key    = "${var.project}/${var.state_account}/${var.region}/${var.environment}/vpc/vpc.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.state_account}-${var.region}"
    key    = "${var.project}/${var.state_account}/${var.region}/${var.environment}/eks/eks.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.state_account}-${var.region}"
    key    = "${var.project}/${var.state_account}/${var.region}/${var.environment}/acm/acm.tfstate"
    region = var.region
  }
}

