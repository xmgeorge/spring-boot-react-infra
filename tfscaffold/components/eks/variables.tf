# Define the variables that will be initialised in etc/{env,versions}_<region>_<environment>.tfvars...
variable "environment" {
  type    = string
  default = "dev"
}

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "component" {
  type        = string
  description = "the component that creates this resourse"
  default     = "eks"
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


variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from."
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster"
  type        = string
  default     = null
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = false
}


variable "cluster_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
}

# variable "ec2_ssh_key" {
#   type = string
# }