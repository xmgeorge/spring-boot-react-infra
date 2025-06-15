output "bastion_ip_address" {
  description = "The public IP address assigned to the instance"
  value       = "ssh -i codeblue.pem ubuntu@${module.bastion_instance["bastion"].public_ip}"
}
