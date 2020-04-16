data "aws_route53_zone" "zone" {
  name = "${var.domain}."
}

resource "aws_route53_record" "writer" {
  name = "${var.name}-db-write.${var.domain}."

  records = [
    "${var.engine_mode != "serverless" ? join(",",aws_rds_cluster.cluster.*.endpoint) : join(",",aws_rds_cluster.serverless.*.endpoint)}",
  ]

  ttl     = "60"
  type    = "CNAME"
  zone_id = "${data.aws_route53_zone.zone.id}"
}

resource "aws_route53_record" "reader" {
  count = "${var.engine_mode != "serverless" ? 1 : 0}"
  name  = "${var.name}-db-read.${var.domain}."

  records = [
    "${aws_rds_cluster.cluster.reader_endpoint}",
  ]

  ttl     = "60"
  type    = "CNAME"
  zone_id = "${data.aws_route53_zone.zone.id}"
}
