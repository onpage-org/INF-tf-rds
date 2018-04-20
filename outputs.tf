output "database_address" {
  value = "${aws_db_instance.rds.address}"
}

output "database_fqdn" {
  value = "${aws_route53_record.record.fqdn}"
}

output "sg_intra" {
  value = "${aws_security_group.intra.id}"
}

output "database_endpoint" {
  value = "${aws_db_instance.rds.endpoint}"
}

output "database_name" {
  value = "${aws_db_instance.rds.name}"
}

output "database_username" {
  value = "${aws_db_instance.rds.username}"
}

output "database_port" {
  value = "${aws_db_instance.rds.port}"
}

output "rds_id" {
  value = "${aws_db_instance.rds.id}"
}

output "rds_arn" {
  value = "${aws_db_instance.rds.arn}"
}
