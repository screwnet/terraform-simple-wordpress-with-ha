#Provider specification
#AWS
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile_name
}
