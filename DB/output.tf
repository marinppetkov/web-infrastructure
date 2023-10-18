output "rds_endpoint" {
  value = "${aws_db_instance.app_db.endpoint}"
}

output "rds_address" {
  value = "${aws_db_instance.app_db.address}"
}

output "rds_arn" {
  value = "${aws_db_instance.app_db.arn}"
}

output rds_name {
  value = split(":",aws_db_instance.app_db.endpoint)[0]
  
  }