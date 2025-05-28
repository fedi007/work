resource "aws_eks_node_group" "nodes_general" {
  count = local.create_eks ? 1 : 0

  version         = var.eks_version
  cluster_name    = aws_eks_cluster.eks[0].name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.eks_node_group_role[0].arn
  ami_type        = var.eks_ami_type
  instance_types  = var.eks_instance_types
  capacity_type   = var.eks_capacity_type

  launch_template {
    id      = aws_launch_template.eks.id
    version = aws_launch_template.eks.latest_version
  }

  # Identifiers of EC2 Subnets to associate with the EKS Node Group.
  # These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME
  # (where CLUSTER_NAME is replaced with the name of the EKS Cluster).
  subnet_ids = var.eks_node_private_subnet_ids

  scaling_config {
    min_size     = var.eks_min_size_cluster
    max_size     = var.eks_max_size_cluster
    desired_size = var.eks_desired_size_cluster
  }

  tags = merge(
    var.eks_common_tags,
    tomap({
      "Name"                                              = var.eks_node_group_name,
      "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned",
      "k8s.io/cluster-autoscaler/enabled"                 = "true",
    })

  )
  labels = {
    Name = var.eks_node_group_name
  }
}
