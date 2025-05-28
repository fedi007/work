module "eks" {
  source = "./modules/eks"

  eks_cluster_name              = local.cluster_name
  env_name                      = local.env
  eks_version                   = local.eks_version
  eks_projet_name               = local.project_name
  eks_cluster_public_subnet_ids = local.public_subnet_ids
  eks_node_private_subnet_ids   = local.private_subnet_ids
  eks_node_group_name           = "${local.env}-${local.project_name}-node-group"
  eks_capacity_type             = local.eks_capacity_type
  eks_min_size_cluster          = local.eks_min_size_cluster
  eks_max_size_cluster          = local.eks_max_size_cluster
  eks_desired_size_cluster      = local.eks_desired_size_cluster
  eks_instance_types            = local.eks_instance_types
  eks_stage_name                = local.env
  eks_account_id                = data.aws_caller_identity.current.id
  eks_region                    = data.aws_region.current.name
  enable_spot_request           = true

  eks_common_tags = {
    name          = local.cluster_name
    environment   = local.env,
    isStoppable   = true,
    project       = local.project_name
    multi-tenancy = false
  }
  eks_map_admin_users = [
    {
      iam_user = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform"
      username = "terraform",
      groups   = ["system:masters"]
    }
  ]
}

