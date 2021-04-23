resource "aws_vpc" "jenkins_vpc" {
  cidr_block = vars.vpc_cidr_block
}
