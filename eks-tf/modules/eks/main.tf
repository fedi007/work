resource "aws_eks_cluster" "eks" {
  count = local.create_eks ? 1 : 0

  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids              = var.eks_cluster_public_subnet_ids
    security_group_ids      = [aws_security_group.eks.id]
  }

  tags = merge(
    var.eks_common_tags,
    tomap({
      "Name" = var.eks_cluster_name
    })
  )
}

resource "aws_security_group" "eks" {
  name        = "${var.eks_cluster_name}-sg"
  description = "Security group for the EKS cluster ${var.eks_cluster_name}"
  vpc_id      = data.aws_subnet.sbn.vpc_id

  #  ingress {
  #    description = "All traffic from OnPrem"
  #    from_port   = 0
  #    to_port     = 0
  #    protocol    = "-1"
  #    cidr_blocks = ["10.0.0.0/8"]
  #  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name"                     = "${var.eks_cluster_name}-sg",
    "karpenter.sh/discovery\t" = "${var.eks_cluster_name}"

  }
}

resource "aws_iam_openid_connect_provider" "eks_openID_connect" {
  count = local.create_eks ? 1 : 0

  url             = aws_eks_cluster.eks[0].identity[0].oidc[0].issuer
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.identity_oidc_issuer[0].certificates.0.sha1_fingerprint]
  tags            = var.eks_common_tags
}
