# terraform-aws-network-hubandspoke

[![Terraform](https://github.com/imjoseangel/terraform-aws-network-hubandspoke/actions/workflows/terraform.yml/badge.svg)](https://github.com/imjoseangel/terraform-aws-network-hubandspoke/actions/workflows/terraform.yml)

## AWS Hub and Spoke Architecture with AWS Transit Gateway - Terraform Module

This Terraform module deploys a hub network in specific account with a Transit Gateway

### NOTES

* Cross-account support

## Usage in Terraform 1.0

```terraform
module "network-hubandspoke" {
  source   = "github.com/imjoseangel/terraform-aws-network-hubandspoke"
  name     = "terraform-backend"
}
```

## Authors

Originally created by [imjoseangel](http://github.com/imjoseangel)

## License

[MIT](LICENSE)
