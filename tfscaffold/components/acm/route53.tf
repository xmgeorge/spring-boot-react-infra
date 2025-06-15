module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = data.aws_route53_zone.selected.name
  zone_id     = data.aws_route53_zone.selected.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.georgeulahannan.live",
  ]

  wait_for_validation = true

  tags = {
    Name = "georgeulahannan.live"
  }
}


data "aws_route53_zone" "selected" {
  name = "georgeulahannan.live."
}