variable "tags" {
  type = "map"
  description = "common tags to add to the ressources"
  default = {}
}

variable "domain" {}

variable "service_name" {}

variable "hostname" {
  default = "db"
}

variable "short_name_length" {
  default = 4
}

variable "subnet_ids" {
  type = "list"
}

variable "vpc_id" {}

variable "instance_class" {
  default = "db.t2.small"
}

variable "allocated_storage" {
  default = "16"
}

variable "csgs" {
  type    = "list"
  default = []
}

/*variable "access_cidr_blocks" {
  type    = "list"
  default = []
}*/

variable "ingress_port_from" {
  default = 3306
}

variable "ingress_port_to" {
  default = 3306
}

variable "root_password" {}

variable "engine" {
  default = "mysql"
}

variable "engine_version" {
  default = "5.6.37"
}

variable "multi_az" {
  default = false
}

variable "snapshot_identifier" {
  default = ""
}

variable "database_name" {
  default = "root"
}

variable "publicly_accessible" {
  default = false
}

variable "username" {
  default = "root"
}
