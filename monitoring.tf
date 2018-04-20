data "aws_iam_policy_document" "trust_policy" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {

      identifiers = [
        "monitoring.rds.amazonaws.com"
      ]

      type = "Service"

    }

  }

}

resource "aws_iam_role" "role" {
  assume_role_policy = "${data.aws_iam_policy_document.trust_policy.json}"
}

resource "aws_iam_role_policy_attachment" "monitoring" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
  role       = "${aws_iam_role.role.name}"
}
