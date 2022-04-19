# INF-tf-rds

Terraform module for deploying an Aurora RDS cluster

This project is [internal open source](https://en.wikipedia.org/wiki/Inner_source)
and currently maintained by the [INF](https://github.com/orgs/ryte/teams/inf).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 0.12)

## Providers

The following providers are used by this module:

- <a name="provider_aws"></a> [aws](#provider\_aws)

- <a name="provider_random"></a> [random](#provider\_random)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [aws_db_subnet_group.sng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) (resource)
- [aws_rds_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) (resource)
- [aws_rds_cluster.serverless](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster) (resource)
- [aws_rds_cluster_instance.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance) (resource)
- [aws_route53_record.reader](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) (resource)
- [aws_route53_record.writer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) (resource)
- [aws_security_group.intra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) (resource)
- [aws_security_group_rule.allow_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) (resource)
- [aws_security_group_rule.sg_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) (resource)
- [random_id.final_snapshot](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) (data source)
- [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) (data source)
- [aws_route53_zone.zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_domain"></a> [domain](#input\_domain)

Description: Domain in which the FQDNs are created

Type: `any`

### <a name="input_master_credentials"></a> [master\_credentials](#input\_master\_credentials)

Description: Username and password for master user (see [Master user credentials](#master-user-credentials))

Type: `map(string)`

### <a name="input_name"></a> [name](#input\_name)

Description: Cluster name and instance name prefix (also used to generate FQDNs)

Type: `any`

### <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids)

Description: Subnets for the Aurora RDS (should be private subnet)

Type: `list(string)`

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: VPC id the subnets will be defined in

Type: `any`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_allow_from_sgs"></a> [allow\_from\_sgs](#input\_allow\_from\_sgs)

Description: a list of security groups for which ingress rules are created

Type: `list`

Default: `[]`

### <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately)

Description: Specifies whether any cluster modifications are applied immediately, or during the next maintenance window

Type: `bool`

Default: `false`

### <a name="input_auto_pause"></a> [auto\_pause](#input\_auto\_pause)

Description: Whether to enable automatic pause. A DB cluster can be paused only when it's idle (it has no connections).

Type: `bool`

Default: `false`

### <a name="input_backtrack_window"></a> [backtrack\_window](#input\_backtrack\_window)

Description: The target backtrack window, in seconds. Only available for aurora engine currently (as of 2018-11-06)

Type: `number`

Default: `0`

### <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period)

Description: Days to keep backups

Type: `number`

Default: `30`

### <a name="input_cloudwatch_log_types"></a> [cloudwatch\_log\_types](#input\_cloudwatch\_log\_types)

Description: Log types to write to cloudwatch (audit, error, general, slowquery)

Type: `list(string)`

Default:

```json
[
  "error"
]
```

### <a name="input_db_cluster_parameter_group_name"></a> [db\_cluster\_parameter\_group\_name](#input\_db\_cluster\_parameter\_group\_name)

Description: A cluster parameter group to associate with the cluster.

Type: `string`

Default: `""`

### <a name="input_engine"></a> [engine](#input\_engine)

Description: Aurora RDS engine (aurora-mysql or aurora-postgresql)

Type: `string`

Default: `"aurora-mysql"`

### <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode)

Description: The database engine mode. Defaults to: provisioned, set to serverless if you want to create rds-serverless

Type: `string`

Default: `"provisioned"`

### <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version)

Description: Version of the DB engine

Type: `string`

Default: `"5.7.12"`

### <a name="input_instances"></a> [instances](#input\_instances)

Description: priority and type of instances (see [Instance configuration](#instance-configuration))

Type:

```hcl
map(object({
    instance_type = string
    tier          = number
  }))
```

Default: `{}`

### <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity)

Description: The maximum capacity for an Aurora DB cluster in serverless DB engine mode.

Type: `number`

Default: `2`

### <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity)

Description: The minimum capacity for an Aurora DB cluster in serverless DB engine mode.

Type: `number`

Default: `1`

### <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled)

Description: Enable performance insights

Type: `bool`

Default: `true`

### <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window)

Description: The daily time range (UTC) during which automated backups are created if automated backups are enabled

Type: `string`

Default: `"00:00-02:00"`

### <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window)

Description: The weekly time range (UTC) during which system maintenance can occur

Type: `string`

Default: `"Mon:02:00-Mon:04:00"`

### <a name="input_seconds_until_auto_pause"></a> [seconds\_until\_auto\_pause](#input\_seconds\_until\_auto\_pause)

Description: The time, in seconds, before an Aurora DB cluster in serverless mode is paused.

Type: `number`

Default: `300`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: common tags to add to the ressources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn)

Description: Aurora RDS cluster ARN

### <a name="output_cluster_port"></a> [cluster\_port](#output\_cluster\_port)

Description: Database port

### <a name="output_reader_fqdn"></a> [reader\_fqdn](#output\_reader\_fqdn)

Description: Domain name for reader endpoint

### <a name="output_sg"></a> [sg](#output\_sg)

Description: Security group for database

### <a name="output_sg_intra"></a> [sg\_intra](#output\_sg\_intra)

Description: DEPRECATED: Security group allowed for access

### <a name="output_writer_fqdn"></a> [writer\_fqdn](#output\_writer\_fqdn)

Description: Domain name for writer endpoint
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

### module
```hcl
module "my_db_cluster" {
  source = "github.com/ryte/INF-tf-rds.git?ref=v0.5.0"

  tags                 = local.common_tags
  domain               = local.domain
  name                 = "my_db_cluster_name"
  engine               = "aurora-mysql"
  engine_version       = "5.7.mysql_aurora.2.07.2"
  master_credentials   = local.my_db_cluster_credentials
  vpc_id               = data.terraform_remote_state.vpc.vpc_id
  subnet_ids           = data.terraform_remote_state.vpc.subnet_private

  allow_from_sgs = [
    data.terraform_remote_state.setup.outputs.jumphost_cosg,
    data.terraform_remote_state.something_else.outputs.sg,
  ]

  instances = local.my_db_instances[var.environment]
}
```

#### Aurora Serverless
```hcl
module "serverless" {
  source = "github.com/ryte/INF-tf-rds.git?ref=v0.5.1"
  tags                     = local.common_tags
  domain                   = local.domain
  name                     = "my_db_cluster_name"
  engine                   = "aurora"
  engine_mode              = "serverless"
  engine_version           = "5.6.10a"
  master_credentials       = local.authentication_db_credentials
  vpc_id                   = data.terraform_remote_state.vpc.vpc_id
  subnet_ids               = data.terraform_remote_state.vpc.subnet_private
  apply_immediately        = true
  backtrack_window         = 0
  backup_retention_period  = 30
  auto_pause               = true
  max_capacity             = 2
  min_capacity             = 1
  seconds_until_auto_pause = 300
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.custom_serverless.name
}
```

### Master user credentials

To not write the credentials in git, we use `random_id` and `random_password`.
The username has to start with a letter, so the username is prefixed with a 'u'.

```hcl
resource "random_id" "username" {
  byte_length = 8
  prefix      = "u"
}

resource "random_password" "password" {
  length = 20
  special = false
}

locals {
  lifecycle {
    ignore_changes = ["my_db_cluster_credentials"]
  }

  "my_db_cluster_credentials" = {
    "user"     = random_id.username.hex
    "password" = random_password.password.result
  }
}
```

### Instance configuration

Amount, type and failover priority are specified as a map with:
- key: Name of the database instance
- `tier`: The `promotion_tier`/failover priority, number between 0-15 (highest to
  lowest priority)
- `instance_type`: The `instance_type`/instance size (see [AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.html))

```hcl
locals {
  my_db_instances = {
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
`instances = local.my_db_instances[var.environment]`

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

mysql-shell: $(SOCKET)
	mysql -u$(DB_USER) -p$(DB_PASS) -hlocalhost --protocol=TCP -P$(PORT)
	$(DISCONNECT)

plan: $(SOCKET)
	terraform get
	terraform plan -out plan
	$(DISCONNECT)

apply: $(SOCKET)
	@$(MAKE) -f ../Makefile $@
	$(DISCONNECT)

destroy: $(SOCKET)
	@$(MAKE) -f ../Makefile $@
	$(DISCONNECT)

%: force
	@$(MAKE) -f ../Makefile $@
force: ;
```

which makes the database usable at `localhost:9000` when terraform is running

```hcl
provider "mysql" {
  endpoint = "localhost:9000"
  username = lookup(data.terraform_remote_state.database.my_db_cluster_master_credentials, "user")
  password = lookup(data.terraform_remote_state.database.my_db_cluster_master_credentials, "password")
}
```


## Authors

- [Armin Grodon](https://github.com/x4121)
- [Markus Schmid](https://github.com/h0raz)

## Changelog

- 0.5.1 - Add `engine_mode` with serverless (default is provisioned)
- 0.5.0 - Add `allow_from_sgs` to work around "5 security groups per EC2"-limit (deprecates `intra_sg`)
- 0.4.1 - Set cost allocation tags
- 0.4.0 - use map instead of list for instance config and use data for availibility zones now
- 0.3.0 - Upgrade to terraform 0.12.x
- 0.2.1 - Added sg to output
- 0.2.0 - Switch from RDS to Aurora RDS.
- 0.1.1 - Separate variable for name generation.
- 0.1.0 - Initial release.

## License

This software is released under the MIT License (see `LICENSE`).
