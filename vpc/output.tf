
output "public_ip-web1" {
value = aws_instance.web-server.public_ip
}
output "public_ip-web2" {
value = aws_instance.web-server-2.public_ip
}


output "pub_snet_1_id" {
    value = aws_subnet.pub-snet-1.id
}

output "pub_snet_2_id" {
    value = aws_subnet.pub-snet-2.id
}

output "db_snet_1_id" {
    value = aws_subnet.db-snet-1.id
}

output "db_snet_2_id" {
    value = aws_subnet.db-snet-2.id
}