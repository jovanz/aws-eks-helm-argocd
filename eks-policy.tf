resource "aws_iam_role" "iam_role_eks_cluster_dev" {
  name               = "iam_role_eks_cluster_dev"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.iam_role_eks_cluster_dev_doc.json

  managed_policy_arns = [data.aws_iam_policy.AWSEKSClusterPolicy.arn]

  tags = {
    "Name" = "iam_role_eks_cluster_dev"
  }
}

resource "aws_iam_role_policy_attachment" "iam_role_pa_eks_cluster_dev" {
  role       = aws_iam_role.iam_role_eks_cluster_dev.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "iam_role_pa_eks_worker_node_policy" {
  role       = aws_iam_role.iam_role_eks_cluster_dev.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "iam_role_pa_eks_cni_policy" {
  role       = aws_iam_role.iam_role_eks_cluster_dev.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "iam_role_pa_ec2_readonly_container_registry" {
  role       = aws_iam_role.iam_role_eks_cluster_dev.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
