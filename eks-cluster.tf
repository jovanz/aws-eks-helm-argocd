resource "aws_eks_cluster" "eks_cluster_dev" {
  name                      = "eks-jofo-dev"
  version                   = "1.24"
  role_arn                  = aws_iam_role.iam_role_eks_cluster_dev.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    endpoint_public_access  = true
    endpoint_private_access = true
    subnet_ids              = aws_subnet.eks_private_subnet.*.id
    security_group_ids      = [aws_security_group.eks_sg_dev.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam_role_pa_eks_cluster_dev,
    aws_cloudwatch_log_group.eks_cw_group_dev
  ]

  tags = {
    "Name" = "eks-jofo-dev"
  }
}

resource "aws_eks_node_group" "eks_node_group_dev" {
  cluster_name    = aws_eks_cluster.eks_cluster_dev.name
  node_group_name = "eks-jofo-nodegroup-dev"
  node_role_arn   = aws_iam_role.iam_role_eks_cluster_dev.arn
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t3a.small"]
  subnet_ids      = aws_subnet.eks_private_subnet.*.id

  scaling_config {
    min_size     = 2
    max_size     = 5
    desired_size = 3
  }

  depends_on = [
    aws_iam_role_policy_attachment.iam_role_pa_ec2_readonly_container_registry,
    aws_iam_role_policy_attachment.iam_role_pa_eks_cni_policy,
    aws_iam_role_policy_attachment.iam_role_pa_eks_worker_node_policy
  ]

  tags = {
    "Name" = "eks-jofo-node-group-dev"
  }
}

