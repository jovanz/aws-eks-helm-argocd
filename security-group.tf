resource "aws_security_group" "eks_sg_dev" {
  name        = "eks_sg_dev"
  description = "Security Group for EKS"
  vpc_id      = aws_vpc.eks_main_vpc.id

  tags = {
    "Name" = "eks_sg_dev"
  }
}

resource "aws_security_group_rule" "eks_sg_dev_in_all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.eks_sg_dev.id
}

resource "aws_security_group_rule" "eks_sg_dev_eg_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.eks_sg_dev.id
}
