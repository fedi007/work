data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "az" {}

data "aws_vpc" "current" {
  filter {
    name   = "tag:Name"
    values = ["cicd-${local.project_name}-vpc"]
  }
  default = false
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_availability_zones.az.names)
  vpc_id   = data.aws_vpc.current.id
  filter {
    name   = "tag:Name"
    values = ["cicd-${each.value}-cicd-${local.project_name}-private-subnet"]
  }
}
data "aws_subnet" "public" {
  for_each = toset(data.aws_availability_zones.az.names)
  vpc_id   = data.aws_vpc.current.id
  filter {
    name   = "tag:Name"
    values = ["cicd-${each.value}-cicd-${local.project_name}-private-subnet"]
  }
}

data "aws_security_group" "bastion" {
  name = "adad-ec2-bastion-${local.env}-sg"
}

data "aws_caller_identity" "current_account" {}


