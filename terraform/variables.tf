#"67.176.80.56/32" - gwyn
variable "jenkins_ssh_allowed_ingress" {
  type = list(string)

  default     = ["73.217.92.18/32"]
  description = "IP addresses allowed to access network resources."
}

variable "region" {
  type = string

  default     = "us-west-2"
  description = "Region to host VPC within."
}


variable "vpc_cidr_block" {
  type = string

  default = "192.168.8.0/22"
  description = "cidr block for your jenkins vpc"
}

variable "public_key" {
  type = string

  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCb4VQnyP0WFkDCnqBy3pDCq2xAQL/tbhN2/IhesaXbdNz21zKRPojqAk1iKDb9kZWSeWGEYxiKqsbj+tNot5Eu4d276/1oSMlMUZKFcGYR00rmkqRlj0oQeTkGa9IYKhRd3xZwMKOrSQoeBp9HjhoR768Mm4CAID8hV8Aw7UUhFjpSUE6E/pJYYe7VvePbEqt3HWtgxErNvcNAFwXTDfFlgg+MP+65Ewh6U8uQfalKRACRLK/PwyNNr2ZUEN6ZXyEICcvUVZpZGHlbh9m7rYYnBnVF+C+iaXsXpg8J4ZbpbmHdJ4ujlefj6TQOK3g/rQsgR8tFkmaD1r9YYLjERQLjEXBjG4U66McIWgkh6jAnJErKFrOBwtIbZPcH08l9COzy+fHFyVYUHaquCmmGhZrb5kbTlLBvsk8RRCXBbRIMIOT+xC5pFk8Cg+MEtLv/7tAKTFn6MaBQFYqSaKvoD6x8gSz6Vq3Fv0xfgFEWHYqbFpiEkPJEUAxEvMK2U/b9DGU= jams@patchworkplaytechniqueio.local"
  description = "The ssh key to use when launching instances associated with Jenkins"
}

variable "jenkins_web_ui_allowed_ingress" {
  type = list(string)

  default     = ["73.217.92.18  /32"]
  description = "Hosts Jenkins is allow egress to."
}

variable "jenkins_allowed_egress" {
  type = list(string)

  default = [
    "52.167.253.43/32", #"Server hosting jenkins plugins"
    "0.0.0.0/0"         #github. sorry I can't do better
  ]
  description = "Places one can contact"
}

# https://alt.fedoraproject.org/cloud/
# to get the current list of valid AMIs
# scroll down to 'Fedora 33 Cloud Base Images for Amazon Public Cloud'
# and in the 'x86_64 AMIs' section, click on the 'click to launch button'
variable "jenkins_host_ami_id" {
  type = map(string)

  default = {
    "us-east-1" = "ami-01efb339f953fdf36",
    "us-west-2" = "ami-0467cd5075b6ae963"
  }

  description = "map of valid amis for various regions"
}

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions
variable "jenkins_region" {
  type = string

  default     = "us-west-2"
  description = "region to host your jenkins within"
}

variable "jenkins_availability_zone" {
  type = string
  default = "us-west-2a"
  description = "AZ for your jinkies"
}
