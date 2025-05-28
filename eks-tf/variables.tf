locals {
  env          = terraform.workspace
  project_name = "adad"
  cluster_name = "${local.env}-${local.project_name}-cluster-assesment"
  stage_name   = "cicd"
  # --- Network --
  private_subnet_ids = [for az in data.aws_availability_zones.az.names : data.aws_subnet.private[az].id]
  public_subnet_ids  = [for az in data.aws_availability_zones.az.names : data.aws_subnet.public[az].id]
  #   ---  EKS ---
  eks_version              = "1.32"
  eks_capacity_type        = "SPOT"
  eks_min_size_cluster     = 2
  eks_max_size_cluster     = 8
  eks_desired_size_cluster = 3
  #eks_instance_types       = ["t4g.medium", "m6g.medium",  "r6g.medium"]
  eks_instance_types = ["t3.large", "t2.large", "t3.xlarge", "t2.xlarge", "m5.large", "r5.large"]


}
