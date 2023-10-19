output "efs_dns" {
  value = "${aws_efs_file_system.web-efs.dns_name }"
}

output "efs_id" {
  value = "${aws_efs_file_system.web-efs.id}"
}
