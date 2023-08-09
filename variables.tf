variable "transit_gateway_id" {
  type        = string
  description = "Transit Gateway ID. **If you specify this value, transit_gateway_attributes can't be set**."
  default     = null
}

variable "identifier" {
  type        = string
  description = "String to identify the whole Hub and Spoke environment."
}

variable "transit_gateway_description" {
  type        = string
  description = "Transit Gateway Description"
  default     = null
}

variable "create_transit_gateway" {
  description = "Whether to create transit gateway or not"
  type        = bool
  default     = true
}

variable "transit_gateway_attributes" {
  description = "Attributes about the new Transit Gateway to create. **If you specify this value, transit_gateway_id can't be set**:"
  type        = any
  default     = {}

  validation {
    error_message = "Only valid key values for var.transit_gateway: \"name\", \"description\", \"amazon_side_asn\", \"auto_accept_shared_attachments\", \"dns_support\", \"multicast_support\", \"transit_gateway_cidr_blocks\", \"vpc_ecmp_support\", or \"tags\"."
    condition = length(setsubtract(keys(var.transit_gateway_attributes), [
      "name",
      "description",
      "amazon_side_asn",
      "auto_accept_shared_attachments",
      "dns_support",
      "multicast_support",
      "transit_gateway_cidr_block",
      "vpn_ecmp_support",
      "tags"
    ])) == 0
  }
}

variable "cidr_block" {
  description = "IPv4 CIDR range to assign to VPC if creating VPC or to associate as a secondary IPv6 CIDR. Overridden by var.vpc_id output from data.aws_vpc."
  default     = "10.100.8.0/22"
  type        = string
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "az_count" {
  type        = number
  description = "Searches region for # of AZs to use and takes a slice based on count. Assume slice is sorted a-z."
  default     = 2
}
