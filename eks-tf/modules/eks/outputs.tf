output "eks_sg" {
  value = aws_security_group.eks.id
}

output "identity_oidc_issuer" {
  value = aws_eks_cluster.eks[0].identity[0].oidc[0].issuer
}