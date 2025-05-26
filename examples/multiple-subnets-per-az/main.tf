module "vpc" {
  source  = "SevenPico/vpc/aws"
  version = "3.0.0"
  context = module.context.self
  enabled = module.context.enabled

  assign_generated_ipv6_cidr_block          = false
  default_network_acl_deny_all              = false
  default_route_table_no_routes             = false
  default_security_group_deny_all           = true
  dns_hostnames_enabled                     = true
  dns_support_enabled                       = true
  instance_tenancy                          = "default"
  internet_gateway_enabled                  = true
  ipv4_additional_cidr_block_associations   = {}
  ipv4_cidr_block_association_timeouts      = null
  ipv4_primary_cidr_block                   = var.vpc_cidr_block
  ipv4_primary_cidr_block_association       = null
  ipv6_additional_cidr_block_associations   = {}
  ipv6_cidr_block_association_timeouts      = null
  ipv6_cidr_block_network_border_group      = null
  ipv6_egress_only_internet_gateway_enabled = false
  ipv6_primary_cidr_block_association       = null


}

module "subnets" {
  source = "../../"
  context = module.context.self
  enabled = module.context.enabled

  availability_zones      = var.availability_zones
  vpc_id                  = module.vpc.vpc_id
  igw_id                  = [module.vpc.igw_id]
  ipv4_enabled            = true
  ipv6_enabled            = false
  ipv6_egress_only_igw_id = [module.vpc.ipv6_egress_only_igw_id]
  ipv4_cidr_block         = [module.vpc.vpc_cidr_block]
  ipv6_cidr_block         = [module.vpc.vpc_ipv6_cidr_block]
  nat_gateway_enabled     = false
  nat_instance_enabled    = false
  route_create_timeout    = "5m"
  route_delete_timeout    = "10m"

  subnet_type_tag_key = "cpco.io/subnet/type"

  subnets_per_az_count = var.subnets_per_az_count
  subnets_per_az_names = var.subnets_per_az_names
}
