output "writer_fqdn" {
  value = "${aws_route53_record.writer.fqdn}"
}

output "reader_fqdn" {
  value = "${aws_route53_record.reader.fqdn}"
}

output "sg_intra" {
  value = "${aws_security_group.intra.id}"
}

output "cluster_arn" {
  value = "${aws_rds_cluster.cluster.arn}"
}

output "cluster_port" {
  value = "${aws_rds_cluster.cluster.port}"
}
