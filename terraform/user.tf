# resource "aws_iam_user" "jenkins" {
#   name = "jenkins"
#   path = "/"
# }

# resource "aws_iam_user_ssh_key" "jenkins_ssh_key" {
#   username   = aws_iam_user.jenkins.name
#   encoding   = "SSH"
#   public_key = var.public_key
# }

resource "aws_key_pair" "jenkins_ssh_key" {
  key_name = "jenkins_ssh_key"
  public_key = var.public_key
}
