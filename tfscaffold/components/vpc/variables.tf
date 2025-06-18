variable "environment" {
  type = string
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
  default     = "vpc"
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


variable "cidr" {
  type        = string
  description = "vpc cidr"
  default     = "10.0.0.0/16"
}

variable "enable_nat_gateway" {
  type = bool
}

variable "single_nat_gateway" {
  type = bool
}

variable "enable_vpn_gateway" {
  type = bool
}

variable "one_nat_gateway_per_az" {
  type = bool
}

variable "map_public_ip_on_launch" {
  type = bool
}