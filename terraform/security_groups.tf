resource "aws_security_group" "allow_ssh_access" {
  vpc_id = aws_vpc.jenkins_vpc.id

  name = "Allow ssh access to jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.jenkins_ssh_allowed_ingress
  }

  tags = {
    Name = "allow_ssh_access"
  }
}

resource "aws_security_group" "allow_http_access" {
  vpc_id = aws_vpc.jenkins_vpc.id
  name   = "Allow http access to jenkins"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.jenkins_web_ui_allowed_ingress
  }

  tags = {
    Name = "allow_http_access_to_jenkins"
  }
}

resource "aws_security_group" "allowed_egress" {
  vpc_id = aws_vpc.jenkins_vpc.id

  name = "Jenkins allowed egress"
  tags = {
    Name = "Jenkins_allowed_egress"
  }
}

resource "aws_security_group_rule" "allowed_egress_https" {
  type = "egress"
  description = "When cloning git repos, we may need https access. Also, grants access to jenkins update server"

  from_port = 443
  to_port   = 443

  protocol    = "tcp"
  cidr_blocks = var.jenkins_allowed_egress

  security_group_id = aws_security_group.allowed_egress.id
}

resource "aws_security_group_rule" "allowed_egress_ssh" {
  type = "egress"
  description = "When cloning git repos, we may need ssh access"

  from_port = 22
  to_port   = 22

  protocol    = "tcp"
  cidr_blocks = var.jenkins_allowed_egress

  security_group_id = aws_security_group.allowed_egress.id
}
