resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.eks_stage_name}-${var.eks_projet_name}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_doc.json
}

resource "aws_iam_role" "eks_node_group_role" {
  count = local.create_eks ? 1 : 0

  name               = "${var.eks_stage_name}-${var.eks_projet_name}-eks-node_group-role"
  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role[0].json
}

resource "aws_iam_policy" "pod" {
  name        = "eks-pod-policy-assesment"
  description = "IAM policy for eks pod role"
  policy      = data.aws_iam_policy_document.pod.json
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = local.create_eks ? toset(local.eks_node_managed_policy_list) : []
  role       = aws_iam_role.eks_node_group_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/${each.key}"
}

resource "aws_iam_role_policy_attachment" "custom" {
  count      = local.create_eks ? 1 : 0
  role       = aws_iam_role.eks_node_group_role[0].name
  policy_arn = aws_iam_policy.pod.arn
}

resource "aws_iam_role" "eks_pod_role" {
  count              = local.create_eks ? 1 : 0
  name               = "${var.eks_stage_name}-${var.eks_projet_name}-eks-pod-role"
  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "pod" {
  count      = local.create_eks ? 1 : 0
  role       = aws_iam_role.eks_pod_role[0].name
  policy_arn = aws_iam_policy.pod.arn
}


