#-------------------------------
# AWS TRANSIT GATEWAY
#-------------------------------

resource "aws_ec2_transit_gateway" "main" {
  count = var.create_transit_gateway ? 1 : 0

  description                     = var.transit_gateway_description
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  amazon_side_asn                 = try(var.transit_gateway_attributes.amazon_side_asn, "64512")
  auto_accept_shared_attachments  = try(var.transit_gateway_attributes.auto_accept_shared_attachments, "disable")
  dns_support                     = try(var.transit_gateway_attributes.dns_support, "enable")
  multicast_support               = try(var.transit_gateway_attributes.multicast_support, "disable")
  transit_gateway_cidr_blocks     = try(var.transit_gateway_attributes.transit_gateway_cidr_blocks, [])
  vpn_ecmp_support                = try(var.transit_gateway_attributes.vpn_ecmp_support, "enable")

  tags = merge({
    Name = try(var.transit_gateway_attributes.name, "tgw-hubspoke")
  }, try(var.transit_gateway_attributes.tags, {}))
}
