resource "aws_db_instance" "rds" {
  // https://www.terraform.io/docs/providers/aws/r/db_instance.html
  // https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
  allocated_storage = "${var.allocated_storage}"

  allow_major_version_upgrade = false
  apply_immediately           = true
  auto_minor_version_upgrade  = false
  backup_retention_period     = 30
  backup_window               = "00:00-02:00"
  copy_tags_to_snapshot       = true
  db_subnet_group_name        = "${aws_db_subnet_group.sng.name}"
  engine                      = "${var.engine}"
  engine_version              = "${var.engine_version}"
  final_snapshot_identifier   = "${var.project}-${var.environment}-rds-final-snapshot"
  identifier                  = "${var.project}-${var.environment}-rds"
  instance_class              = "${var.instance_class}"
  maintenance_window          = "Mon:02:00-Mon:04:00"
  monitoring_interval         = "10"                                                                         # 10
  monitoring_role_arn         = "${aws_iam_role.role.arn}"
  multi_az                    = "${var.multi_az}"
  name                        = "${var.database_name}"
  password                    = "${var.root_password}"
  publicly_accessible         = "${var.publicly_accessible}"
  snapshot_identifier         = "${var.snapshot_identifier}"
  storage_encrypted           = true
  storage_type                = "gp2"                                                                        # do not use for tablespace < 100 G
  tags                        = "${merge(local.tags, map("Name", "${var.project}-${var.environment}-rds"))}"
  username                    = "${var.username}"

  vpc_security_group_ids = [
    "${aws_security_group.sg.id}",
  ]
}

resource "aws_db_subnet_group" "sng" {
  subnet_ids = ["${var.subnet_ids}"]
  tags       = "${merge(local.tags, map("Name", "${var.project}-${var.environment}-subnet-group"))}"
}

resource "aws_security_group" "sg" {
  // name_prefix = "${local.short_name}-default-sg"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port       = "${var.ingress_port_from}"
    to_port         = "${var.ingress_port_to}"
    protocol        = "tcp"
    security_groups = ["${var.csgs}", "${aws_security_group.intra.id}"]
  }

/*  ingress {
    from_port   = "${var.ingress_port_from}"
    to_port     = "${var.ingress_port_to}"
    protocol    = "tcp"
    cidr_blocks = ["${var.access_cidr_blocks}"]
  }
*/
  tags   = "${merge(local.tags, map("Name", "${var.project}-${var.environment}-rds-sg"))}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group" "intra" {
  // name_prefix = "${local.short_name}-intra-sg"
  tags   = "${merge(local.tags, map("Name", "${var.project}-${var.environment}-rds-intra"))}"
  vpc_id = "${var.vpc_id}"
}
