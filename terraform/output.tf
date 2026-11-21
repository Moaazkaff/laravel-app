output "server_public_ip" {
  description = "EC2 public ip"
  value = aws_instance.server.public_ip
}