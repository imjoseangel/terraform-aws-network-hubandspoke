#-------------------------------
# AWS AVAILABILITY ZONES
#-------------------------------

data "aws_availability_zones" "main" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
