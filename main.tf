#-------------------------------
# AWS TRANSIT GATEWAY
#-------------------------------
resource "aws_ec2_transit_gateway" "main" {
  count = var.create_transit_gateway ? 1 : 0

  description                     = var.transit_gateway_description
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  amazon_side_asn                 = try(var.transit_gateway_attributes.amazon_side_asn, "64513")
  auto_accept_shared_attachments  = try(var.transit_gateway_attributes.auto_accept_shared_attachments, "enable")
  dns_support                     = try(var.transit_gateway_attributes.dns_support, "enable")
  multicast_support               = try(var.transit_gateway_attributes.multicast_support, "disable")
  transit_gateway_cidr_blocks     = try(var.transit_gateway_attributes.transit_gateway_cidr_blocks, [])
  vpn_ecmp_support                = try(var.transit_gateway_attributes.vpn_ecmp_support, "enable")

  tags = merge({
    Name = try(var.transit_gateway_attributes.name, format("tgw-%s", var.identifier))
  }, try(var.transit_gateway_attributes.tags, {}))
}


#-------------------------------
# VPC
#-------------------------------
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = { "Name" = format("tgw-%s", var.identifier) }
}

#-------------------------------
# PUBLIC SUBNETS
#-------------------------------

resource "aws_subnet" "public" {
  for_each = toset(local.azs)

  availability_zone       = each.key
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 3, 0)
  map_public_ip_on_launch = true

  tags = { Name = "${var.identifier}-subnet-public-${each.key}" }
}

#-------------------------------
# PRIVATE SUBNETS
#-------------------------------

resource "aws_subnet" "private" {
  for_each = toset(local.azs)

  availability_zone       = each.key
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 3, 2)
  map_public_ip_on_launch = true

  tags = { Name = "${var.identifier}-subnet-private-${each.key}" }
}
