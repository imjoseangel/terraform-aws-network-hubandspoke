#-------------------------------
# LOCAL VARIABLES
#-------------------------------

locals {
  #-------------------------------
  # TRANSIT GATEWAY
  #-------------------------------
  transit_gateway_id = var.create_transit_gateway ? aws_ec2_transit_gateway.main[0].id : var.transit_gateway_id

  #-------------------------------
  # AVAILABILITY ZONES
  #-------------------------------

  availability_zones_count = slice(data.aws_availability_zones.main.names, 0, var.az_count)

  subnet_netnum_factor = {
    public  = 0
    private = length(local.availability_zones_count)
  }

}
