
output "public_ip-web1" {
value = aws_instance.web-server.public_ip
}
output "public_ip-web2" {
value = aws_instance.web-server-2.public_ip
}
