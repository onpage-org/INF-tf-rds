# INF-tf-rds

Terraform module for deploying an Aurora RDS cluster

This project is [internal open source](https://en.wikipedia.org/wiki/Inner_source)
and currently maintained by the [INF](https://github.com/orgs/ryte/teams/inf).

## Module Input Variables

- `apply_immediately`
    - __description__: Specifies whether any cluster modifications are applied immediately, or during the next maintenance window
    - __type__: `boolean`
    - __default__: false

- `backtrack_window`
    - __description__: The target backtrack window, in seconds. Only available for aurora engine currently (as of 2018-11-06)
    - __type__: `integer`
    - __default__: 0

- `backup_retention_period`
    - __description__: Days to keep backups
    - __type__: `integer`
    - __default__: 30

- `cloudwatch_log_types`
    - __description__: Log types to write to cloudwatch (audit, error, general, slowquery)
    - __type__: `list`
    - __default__: ["error"]

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
    - __description__: priority and type of instances (see [Instance configuration](#instance-configuration))
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


## Dependencies

### random
```hcl
provider "random" {}
```

## Usage

### module
```hcl
module "my_db_cluster" {
  source = "github.com/ryte/INF-tf-rds.git?ref=v0.2.0"

  tags                 = local.common_tags
  domain               = local.domain
  name                 = "my_db_cluster_name"
  engine               = "aurora-mysql"
  engine_version       = "5.7.12"
  master_credentials   = local.authentication_db_master[var.environment]
  vpc_id               = data.terraform_remote_state.vpc.vpc_id
  subnet_ids           = data.terraform_remote_state.vpc.subnet_private

  instances = local.authentication_db_instances[var.environment]
}
```

### Master user credentials

the username has to start with a letter, so the username is prefixed with a 'u'

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
`master_credentials = local.authentication_db_master[var.environment]`

To not write the credentials in git, you can also use `random_string`

```hcl
resource "random_string" "username" {
  length = 15
  special = false
}

resource "random_string" "password" {
  length = 20
  special = false
}

locals {
  lifecycle {
    ignore_changes = ["my_db_cluster_credentials"]
  }

  "my_db_cluster_credentials" = {
    "user" = "u${random_string.username.result}"
    "password" = random_string.password.result
  }
}
```

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
    "development" = {
      main = {
        tier          = 0
        instance_type = "db.t3.small"
      }
      secondary = {
        tier          = 0
        instance_type = "db.t3.small"
      }
    }
    "testing" = [
      main = {
        tier          = 0
        instance_type = "db.t3.small"
      }
      secondary = {
        tier          = 1
        instance_type = "db.t3.small"
      }
    ]
    "production" = [
      main = {
        tier          = 0
        instance_type = "db.r5.large"
      }
      secondary = {
        tier          = 1
        instance_type = "db.t3.medium"
      }
    ]
  }
}
```
within the module:
`instances = local.authentication_db_instances[var.environment]`

### Jumphost configuration

as the jumphost has no access to the database you need to add the database security-group to the jumphost config

the jumphost module supports this from v0.1.1 on

`additional_sgs = [data.terraform_remote_state.database.authentication_intra_sg]`


### Using the database in Terraform

Since the RDS is inside a private VPC, Terraform cannot directly use it within
the mysql provider.

Following Makefile (snippet) creates a ssh named socket over the jumphost.

```Makefile
...
# local port for ssh named socket
PORT       = 9000

# variables to create ssh named socket
DIR        = $(shell pwd)
STATEFILE  = $(DIR)/.db_state
SOCKET     = ssh-tunnel-socket
DISCONNECT = ssh -S $(SOCKET) -O exit dev@jump$(DOMAIN)
DB_HOST    = $(shell jq -r '.my_db_cluster_writer_fqdn.value' $(STATEFILE))
DOMAIN     = $(subst $(noop) $(noop),., $(wordlist 2, $(words $(subst ., ,$(DB_HOST))), $(subst ., ,$(DB_HOST))))
DB_USER    = $(shell jq -r '.my_db_cluster_master_credentials.value.user' $(STATEFILE))
DB_PASS    = $(shell jq -r '.my_db_cluster_master_credentials.value.password' $(STATEFILE))
DB_PORT    = $(shell jq -r '.my_db_cluster_port.value' $(STATEFILE))
...

$(STATEFILE):
	@if ! find $(STATEFILE) -type f -mmin -5 2>/dev/null | grep . 2>/dev/null; then \
	  cd ..;  terraform output -json > $(STATEFILE) || { rm -f $(STATEFILE); exit 1; } \
	fi

$(SOCKET): $(STATEFILE)
	@ssh -M -S $(SOCKET) \
		-fnNT \
		-L "$(PORT):$(DB_HOST):$(DB_PORT)" \
		dev@jump$(DOMAIN)

test: $(SOCKET)
	mysql -umy_db_user -p -hlocalhost --protocol=TCP -P$(PORT) -e 'show grants;'
	$(DISCONNECT)

plan: $(SOCKET)
	terraform get
	terraform plan -out plan
	$(DISCONNECT)

...

.PHONY: test
```

which makes the database usable at `localhost:9000` when terraform is running

```hcl
provider "mysql" {
  endpoint = "localhost:9000"
  username = lookup(data.terraform_remote_state.database.my_db_cluster_master_credentials, "user")
  password = lookup(data.terraform_remote_state.database.my_db_cluster_master_credentials, "password")
}
```

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

- `sg`
    -  __description__: Security group for database
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

- 0.4.0 - use map instead of list for instance config and use data for availibility zones now
- 0.3.0 - Upgrade to terraform 0.12.x
- 0.2.1 - Added sg to output
- 0.2.0 - Switch from RDS to Aurora RDS.
- 0.1.1 - Separate variable for name generation.
- 0.1.0 - Initial release.

## License

This software is released under the MIT License (see `LICENSE`).
