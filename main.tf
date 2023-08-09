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
  availability_zone                           = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id                        = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  cidr_block                                  = element(concat(var.public_subnets, [""]), count.index)
  enable_dns64                                = var.public_subnet_enable_dns64
  enable_resource_name_dns_a_record_on_launch = var.public_subnet_enable_resource_name_dns_a_record_on_launch
  map_public_ip_on_launch                     = var.map_public_ip_on_launch
  private_dns_hostname_type_on_launch         = var.public_subnet_private_dns_hostname_type_on_launch
  vpc_id                                      = aws_vpc.main.id

  tags = merge(
    {
      Name = try(
        var.public_subnet_names[count.index],
        format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index))
      )
    },
    var.tags,
    var.public_subnet_tags,
    lookup(var.public_subnet_tags_per_az, element(var.azs, count.index), {})
  )
}
