resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.vpc_cidr_block
}
