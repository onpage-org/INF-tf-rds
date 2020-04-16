variable "tags" {
  type        = "map"
  description = "common tags to add to the ressources"
  default     = {}
}

variable "domain" {}

variable "name" {}

variable "engine" {
  default = "aurora-mysql"
}

variable "engine_version" {
  default = "5.7.12"
}

variable "master_credentials" {
  type = "map"
}

variable "availability_zones" {
  type    = "list"
  default = ["a", "b", "c"]
}

variable "backup_retention_period" {
  default = 30
}

variable "preferred_backup_window" {
  default = "00:00-02:00"
}

variable "preferred_maintenance_window" {
  default = "Mon:02:00-Mon:04:00"
}

variable "vpc_id" {}

variable "subnet_ids" {
  type = "list"
}

variable "cloudwatch_log_types" {
  type    = "list"
  default = ["error"] // audit, error, general, slowquery
}

variable "performance_insights_enabled" {
  default = true
}

variable "apply_immediately" {
  default = false
}

variable "backtrack_window" {
  description = "not working with aurora-mysql (as of 2018-11-06)"
  default     = 0                                                  //172800
}

variable "instances" {
  type    = "list"
  default = []
}

variable "engine_mode" {
  default = "provisioned"
}

variable "auto_pause" {
  default = "false"
}

variable "max_capacity" {
  default = 2
}

variable "min_capacity" {
  default = 1
}

variable "seconds_until_auto_pause" {
  default = 300
}
