output "alb_arn" {
  description = "ARN of the ALB"
  value       = module.alb.arn
}

output "alb_dns_name" {
  description = "DNS of the ALB"
  value       = module.alb.dns_name
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = module.alb.target_groups["ex-instance"].arn
}

# output "alb_listener_arn_https" {
#   description = "HTTPS listener ARN"
#   value       = module.alb.listeners["ex-https"].listener_arn
# }

output "alb_zone_id" {
  description = "Zone ID for Route53 alias"
  value       = module.alb.zone_id
}
