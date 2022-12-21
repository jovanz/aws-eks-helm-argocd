output "eks-region" {
  value = var.region
}

output "eks-cluster-name" {
  value = aws_eks_cluster.eks_cluster_dev.name
}

output "eks-cluster-endpoint" {
  value = aws_eks_cluster.eks_cluster_dev.endpoint
}
