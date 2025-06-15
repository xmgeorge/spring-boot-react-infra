output "domain_name" {
  value = data.aws_route53_zone.selected.name
}

output "zone_id" {
  value = data.aws_route53_zone.selected.zone_id
}

output "zone_arn" {
 value = data.aws_route53_zone.selected.arn 
}

output "acm_certificate_arn" {
  value = module.acm.acm_certificate_arn
}