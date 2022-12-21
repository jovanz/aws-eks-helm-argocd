resource "aws_cloudwatch_log_group" "eks_cw_group_dev" {
  name              = "/aws/eks/eks-jofo-dev/cluster"
  retention_in_days = 7

  tags = {
    "Name" = "eks-cw-group-dev"
  }
}