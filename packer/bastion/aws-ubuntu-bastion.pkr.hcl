packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}
# variables {
#   instance_role = "SSMInstanceProfile"
# }

variable "aws_region" {
  type = string
  default = "us-east-1"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = join("-", ["bastion", local.timestamp])
  instance_type = "t2.micro"
  region        = var.aws_region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  communicator = "ssh"
  ssh_username = "ubuntu"

}

build {
  name = "bastion"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" {
    use_proxy     = false
    playbook_file = "scripts/playbooks/bastion.yml"
  }

  post-processor "manifest" {}

}
