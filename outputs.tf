output "writer_fqdn" {
  value = "${aws_route53_record.writer.fqdn}"
}

output "reader_fqdn" {
  value = "${join(",",aws_route53_record.reader.*.fqdn)}"
}

output "sg" {
  value = "${aws_security_group.sg.id}"
}

output "sg_intra" {
  value = "${aws_security_group.intra.id}"
}

output "cluster_arn" {
  value = "${var.engine_mode != "serverless" ? join(",",aws_rds_cluster.cluster.*.arn) : join(",",aws_rds_cluster.serverless.*.arn)}"
}

output "cluster_port" {
  value = "${var.engine_mode != "serverless" ? join(",",aws_rds_cluster.cluster.*.arn) : join(",",aws_rds_cluster.serverless.*.arn)}"
}
