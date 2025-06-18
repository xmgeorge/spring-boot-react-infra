module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name                       = local.cluster_name
  vpc_id                     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnets                    = data.terraform_remote_state.vpc.outputs.public_subnets
  enable_deletion_protection = false
  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }

  # access_logs = {
  #   bucket = "my-alb-logs"
  # }

  security_groups = [data.terraform_remote_state.vpc.outputs.vpc_default_security_group, ]

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = data.terraform_remote_state.acm.outputs.acm_certificate_arn

      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  target_groups = {
    ex-instance = {
      name_prefix       = "h1"
      protocol          = "HTTP"
      port              = 30080
      target_type       = "instance"
      create_attachment = false
    }

  }

  # route53_records = {
  #   A = {
  #     name    = data.aws_route53_zone.selected.name
  #     type    = "A"
  #     zone_id = data.aws_route53_zone.selected.zone_id
  #   }
  # }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}


# target_groups = {
#     ex-instance = {
#       name_prefix                       = "h1"
#       protocol                          = "HTTP"
#       port                              = 80
#       target_type                       = "instance"
#       deregistration_delay              = 10
#       load_balancing_algorithm_type     = "weighted_random"
#       load_balancing_anomaly_mitigation = "on"
#       load_balancing_cross_zone_enabled = false

#       target_group_health = {
#         dns_failover = {
#           minimum_healthy_targets_count = 2
#         }
#         unhealthy_state_routing = {
#           minimum_healthy_targets_percentage = 50
#         }
#       }

#       health_check = {
#         enabled             = true
#         interval            = 30
#         path                = "/healthz"
#         port                = "traffic-port"
#         healthy_threshold   = 3
#         unhealthy_threshold = 3
#         timeout             = 6
#         protocol            = "HTTP"
#         matcher             = "200-399"
#       }

#       protocol_version = "HTTP1"
#       target_id        = aws_instance.this.id
#       port             = 80
#       tags = {
#         InstanceTargetGroupTag = "baz"
#       }
#     }

data "aws_route53_zone" "selected" {
  name = "georgeulahannan.live."
}

resource "aws_route53_record" "www" {
  for_each = toset([data.aws_route53_zone.selected.name, "*.${data.aws_route53_zone.selected.name}"])

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = each.key
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }

  allow_overwrite = true

}