# Define the variables that will be initialised in etc/{env,versions}_<region>_<environment>.tfvars...
variable "environment" {
}

variable "project" {
}

variable "region" {
}

variable "component" {
  type        = string
  description = "the component that creates this resourse"
  default     = "bastion"
}

variable "default_tags" {
  type        = map(string)
  description = "Map of tags to apply by default to all resources"
}

variable "env_tags" {
  type        = map(string)
  description = "Map of environment tags to apply by default to all resources"
  default     = {}
}

variable "state_account" {
  type        = string
  description = "Account Number for the AWS Account that hosts the remote state files"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "monitoring" {
  type    = bool
  default = false
}

variable "associate_public_ip_address" {
  type    = bool
  default = true

}