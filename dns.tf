data "aws_route53_zone" "zone" {
  name = "${var.domain}."
}

resource "aws_route53_record" "record" {
  name = "${var.hostname}.${var.domain}."

  records = [
    "${aws_db_instance.rds.address}"
  ]

  ttl     = "60"
  type    = "CNAME"
  zone_id = "${data.aws_route53_zone.zone.id}"
}
