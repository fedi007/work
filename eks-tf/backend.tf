terraform {
  backend "s3" {
    bucket         = "adad-tfstates"
    key            = "infra/cicd-layer.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "adad-tfstates-lock"
    acl            = "bucket-owner-full-control"
  }
}