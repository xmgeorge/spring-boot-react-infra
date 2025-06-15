data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.state_account}-${var.region}"
    key    = "${var.project}/${var.state_account}/${var.region}/${var.environment}/vpc/vpc.tfstate"
    region = var.region
  }
}

