data "aws_region" "current" {}

locals {
  "availability_zones" = "${formatlist("%s%s", data.aws_region.current.name, var.availability_zones)}"
}

resource "aws_rds_cluster_instance" "instance" {
  count = "${length(var.instances)}"

  tags                            = "${var.tags}"
  cluster_identifier              = "${aws_rds_cluster.cluster.id}"
  identifier_prefix               = "${var.name}-"
  engine                          = "${var.engine}"
  engine_version                  = "${var.engine_version}"
  instance_class                  = "${element( split(":", element( var.instances, count.index ) ), 1 )}"
  promotion_tier                  = "${element( split(":", element( var.instances, count.index ) ), 0 )}"
  preferred_maintenance_window    = "${var.preferred_maintenance_window}"
  db_subnet_group_name            = "${aws_db_subnet_group.sng.id}"

  apply_immediately               = "${var.apply_immediately}"
}

resource "aws_rds_cluster" "cluster" {
  tags                            = "${var.tags}"
  cluster_identifier              = "${var.name}"
  engine                          = "${var.engine}"
  engine_version                  = "${var.engine_version}"
  availability_zones              = ["${local.availability_zones}"]
  master_username                 = "${var.master_credentials["user"]}"
  master_password                 = "${var.master_credentials["password"]}"
  backup_retention_period         = "${var.backup_retention_period}"
  preferred_backup_window         = "${var.preferred_backup_window}"
  preferred_maintenance_window    = "${var.preferred_maintenance_window}"
  final_snapshot_identifier       = "${var.name}-final-snapshot"
  vpc_security_group_ids          = ["${aws_security_group.sg.id}"]
  db_subnet_group_name            = "${aws_db_subnet_group.sng.id}"
  enabled_cloudwatch_logs_exports = "${var.cloudwatch_log_types}"
  apply_immediately               = "${var.apply_immediately}"
  backtrack_window                = "${var.backtrack_window}"
  storage_encrypted               = true
}

resource "aws_db_subnet_group" "sng" {
  subnet_ids = ["${var.subnet_ids}"]
  tags       = "${merge(var.tags, map("Name", "${var.name}-subnet-group"))}"
}

resource "aws_security_group" "sg" {
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags   = "${merge(var.tags, map("Name", "${var.name}-sg"))}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "sg_ingress" {
  type                     = "ingress"
  from_port                = "${aws_rds_cluster.cluster.port}"
  to_port                  = "${aws_rds_cluster.cluster.port}"
  protocol                 = "tcp"

  security_group_id        = "${aws_security_group.sg.id}"
  source_security_group_id = "${aws_security_group.intra.id}"
}

resource "aws_security_group" "intra" {
  tags   = "${merge(var.tags, map("Name", "${var.name}-intra"))}"
  vpc_id = "${var.vpc_id}"
}
