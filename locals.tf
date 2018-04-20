locals {
  tags = {
    CID         = "${var.cid}"
    Environment = "${var.environment}"
    Module      = "rds"
    Owner       = "${var.owner}"
    Project     = "${var.project}"
    Pet         = "${random_pet.rds.id}"
  }

  short_name = "${substr(var.environment, 0, var.short_name_length)}-${substr(var.project, 0, var.short_name_length)}-rds"
}
