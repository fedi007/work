#provider "kubernetes" {
#  host                   = aws_eks_cluster.eks.endpoint
#  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
#  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
#  #load_config_file       = false
#  config_path = "~/.kube/config"
#  version     = "~> 2.20.0"
#}

resource "aws_autoscaling_schedule" "shutdown" {
  count = local.create_eks ? 1 : 0

  scheduled_action_name  = "shutdown"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "00 21 * * 1-5"
  autoscaling_group_name = aws_eks_node_group.nodes_general[0].resources[0].autoscaling_groups[0].name
}

resource "aws_autoscaling_schedule" "startup_node_genral" {
  count = local.create_eks ? 1 : 0

  scheduled_action_name  = "startup"
  min_size               = var.eks_min_size_cluster
  max_size               = var.eks_max_size_cluster
  desired_capacity       = var.eks_desired_size_cluster
  recurrence             = "30 06 * * 1-5"
  autoscaling_group_name = aws_eks_node_group.nodes_general[0].resources[0].autoscaling_groups[0].name
}

