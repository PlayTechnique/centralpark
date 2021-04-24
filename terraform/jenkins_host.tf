resource "aws_instance" "jenkins" {

  ami = var.jenkins_host_ami_id[var.jenkins_region] #fedora

  associate_public_ip_address = true
  key_name                    = aws_key_pair.jenkins_ssh_key.key_name
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.allow_ssh_access.id, aws_security_group.allow_http_access.id, aws_security_group.allowed_egress.id]
  subnet_id                   = aws_subnet.jenkins_subnet.id

  availability_zone           = var.jenkins_availability_zone

  user_data = <<-EOS
  #!/bin/bash

  dnf -y update

  dnf -y install dnf-plugins-core

  dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo

  dnf -y install docker-ce docker-ce-cli

  systemctl enable docker.service
  systemctl enable containerd.service
  systemctl start docker

  usermod -aG docker fedora

  sudo -u fedora bash -c "docker pull jenkins/jenkins:lts"

  docker run -d -p 8080:8080 --name jinkies jenkins/jenkins:lts
  EOS



  tags = {
    Name = "jinkies"
  }
}
