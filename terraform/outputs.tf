output "jenkins_public_address" {
  value = aws_instance.jenkins.public_ip
}
