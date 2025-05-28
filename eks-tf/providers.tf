provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = {
      managed_by       = "terraform"
      project          = "adad"
      cost_center      = "transverse"
      account_category = local.env == "prod" ? "prod" : "hprod"
    }
  }
}