#"67.176.80.56/32" - gwyn
variable "allowed_ingress" {
  type = list(string)

  default = ["67.176.80.56/32"]
  description = "IP addresses allowed to access network resources."
}

variable "region" {
  type = string

  default = "us-west-2"
  description = "Region to host VPC within."
}

variable "vpc_cidr_block" {
  type = string

  default = "192.168.8.0/22"
  description = "cidr block for your jenkins vpc"
}
