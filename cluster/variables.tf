variable "tags" {
  type = "map"
  description = "common tags to add to the ressources"
  default = {}
}
variable "domain" {}

variable "name" {}
variable "engine" {
  default = "aurora-mysql"
}
variable "engine_version" {
  default = "5.7.12"
}
variable "master_username" {}
variable "master_password" {}
variable "availability_zones" {
  type = "list"
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
