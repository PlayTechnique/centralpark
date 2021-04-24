resource "aws_subnet" "jenkins_subnet" {
  vpc_id     = aws_vpc.jenkins_vpc.id
  cidr_block = cidrsubnet(aws_vpc.jenkins_vpc.cidr_block, 6, 0)

  availability_zone           = var.jenkins_availability_zone
}

resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins_igw"
  }
}

resource "aws_route_table" "jenkins_routes" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }

  tags = {
    Name = "cyan_routes"
  }
}

resource "aws_route_table_association" "aws_access" {
  subnet_id      = aws_subnet.jenkins_subnet.id
  route_table_id = aws_route_table.jenkins_routes.id
}
