variable "tags" {
  description = "common tags to add to the ressources"
  type        = map(string)
  default     = {}
}

variable "domain" {
  description = "Domain in which the FQDNs are created"
}

variable "name" {
  description = "Cluster name and instance name prefix (also used to generate FQDNs)"
}

variable "engine" {
  description = "Aurora RDS engine (aurora-mysql or aurora-postgresql)"
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "Version of the DB engine"
  default     = "5.7.12"
}

variable "master_credentials" {
  description = "Username and password for master user (see [Master user credentials](#master-user-credentials))"
  type        = map(string)
}

variable "backup_retention_period" {
  description = "Days to keep backups"
  default     = 30
}

variable "preferred_backup_window" {
  description = "The daily time range (UTC) during which automated backups are created if automated backups are enabled"
  default     = "00:00-02:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range (UTC) during which system maintenance can occur"
  default     = "Mon:02:00-Mon:04:00"
}

variable "vpc_id" {
  description = "VPC id the subnets will be defined in"
}

variable "subnet_ids" {
  description = "Subnets for the Aurora RDS (should be private subnet)"
  type        = list(string)
}

variable "cloudwatch_log_types" {
  description = "Log types to write to cloudwatch (audit, error, general, slowquery)"
  type        = list(string)
  default     = ["error"] // audit, error, general, slowquery
}

variable "performance_insights_enabled" {
  description = "Enable performance insights"
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  default     = false
}

variable "backtrack_window" {
  description = "The target backtrack window, in seconds. Only available for aurora engine currently (as of 2018-11-06)"
  default     = 0 //172800
}

variable "instances" {
  description = "priority and type of instances (see [Instance configuration](#instance-configuration))"
  type = map(object({
    instance_type = string
    tier          = number
  }))
  default = {}
}

variable "allow_from_sgs" {
  description = "a list of security groups for which ingress rules are created"
  default     = []
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

variable "db_cluster_parameter_group_name" {
  default = ""
}
