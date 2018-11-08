# INF-tf-rds

Terraform module for deploying an Aurora RDS cluster

This project is [internal open source](https://en.wikipedia.org/wiki/Inner_source)
and currently maintained by the [INF](https://github.com/orgs/onpage-org/teams/inf).

## Module Input Variables

- `apply_immediately`
    - __description__: Specifies whether any cluster modifications are applied immediately, or during the next maintenance window
    - __type__: `boolean`
    - __default__: false

- `availability_zones`
    - __description__: Availability zone postfixes for the cluster
    - __type__: `list`
    - __default__: ["a", "b", "c"]

- `backtrack_window`
    - __description__: The target backtrack window, in seconds. Only available for aurora engine currently (as of 2018-11-06)
    - __type__: `integer`
    - __default__: 0
}
- `backup_retention_period`
    - __description__: Days to keep backups
    - __type__: `integer`
    - __default__: 30

- `cloudwatch_log_types`
    - __description__: Log types to write to cloudwatch (audit, error, general, slowquery)
    - __type__: `list`
    - __default__: ["error"]
}
- `domain`
    - __description__: Domain in which the FQDNs are created
    - __type__: `string`

- `engine`
    - __description__: Aurora RDS engine (aurora-mysql or aurora-postgresql)
    - __type__: `string`
    - __default__: aurora-mysql

- `engine_version`
    - __description__: Version of the DB engine
    - __type__: `string`
    - __default__: 5.7.12

- `instances`
    - __description__: Number, priority and type of instances (see [Instance configuration](#instance-configuration))
    - __type__`list`

- `master_credentials`
    - __description__: Username and password for master user (see [Master user credentials](#master-user-credentials))
    - __type__: `map`

- `name`
    -  __description__: Cluster name and instance name prefix (also used to generate FQDNs)
    -  __type__: `string`

- `performance_insights_enabled`
    - __description__: Enable performance insights
    - __type__: `boolean`
    - __default__: true

- `preferred_backup_window`
    - __description__: The daily time range (UTC) during which automated backups are created if automated backups are enabled
    - __type__: `string`
    - __default__: "00:00-02:00"

- `preferred_maintenance_window`
    - __description__: The weekly time range (UTC) during which system maintenance can occur
    - __type__: `string`
    - __default__: "Mon:02:00-Mon:04:00"

- `subnet_ids`
    - __description__: Subnets for the Aurora RDS (should be private subnet)
    - __type__: `list`

- `tags`
    -  __description__: a map of tags which is added to all supporting ressources
    -  __type__: `map`
    -  __default__: {}

- `vpc_id`
    -  __description__: VPC id the subnets will be defined in
    -  __type__: `string`


## Usage

### module
```
module "my_db_cluster" {
  source = "git@github.com:onpage-org/INF-tf-rds.git?ref=v0.2.0"

  tags                 = "${local.common_tags}"
  domain               = "${local.domain}"
  name                 = "my_db_cluster_name"
  engine               = "aurora-mysql"
  engine_version       = "5.7.12"
  master_credentials   = "${local.authentication_db_master[var.environment]}"
  vpc_id               = "${data.terraform_remote_state.vpc.vpc_id}"
  subnet_ids           = "${data.terraform_remote_state.vpc.subnet_private}"

  instances = ["${local.authentication_db_instances[var.environment]}"]
}
```

### Master user credentials
```hcl
locals {
  authentication_db_master = {
    "development" = {
      "user" = "root"
      "password" = "..."
    }
    "testing" = {
      "user" = "root"
      "password" = "..."
    }
    "production" = {
      "user" = "master_user"
      "password" = "..."
    }
  }
}
```
within the module:
`master_credentials = "${local.authentication_db_master[var.environment]}"`

### Instance configuration

Amount, type and failover priority are specified as a list where:
- The amount of instances is the length of the list
- The `promotion_tier`/failover priority is a number from 0-15 (highest to
  lowest priority)
- Separating `:`
- The `instance_class`/instance size (see [AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html))

```hcl
locals {
  authentication_db_instances = {
    "development" = [
      "0:db.t2.small",
    ]
    "testing" = [
      "0:db.t2.small",
      "0:db.t2.small",
    ]
    "production" = [
      "1:db.t2.medium",
      "0:db.r3.large",
    ]
  }
}
```
within the module:
`instances = ["${local.authentication_db_instances[var.environment]}"]`

## Outputs

- `cluster_arn`
    -  __description__: Aurora RDS cluster ARN
    -  __type__: `string`

- `cluster_port`
    -  __description__: Database port
    -  __type__: `string`

- `reader_fqdn`
    -  __description__: Domain name for reader endpoint
    -  __type__: `string`

- `sg_intra`
    -  __description__: Security group allowed for access
    -  __type__: `string`

- `writer_fqdn`
    -  __description__: Domain name for writer endpoint
    -  __type__: `string`


## Authors

- [Armin Grodon](https://github.com/x4121)
- [Markus Schmid](https://github.com/h0raz)

## Changelog

- 0.2.0 - Switch from RDS to Aurora RDS.
- 0.1.1 - Separate variable for name generation.
- 0.1.0 - Initial release.

## License

This software is released under the MIT License (see `LICENSE`).
