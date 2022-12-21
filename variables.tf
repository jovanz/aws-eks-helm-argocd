variable "default_tags" {
  type        = map(string)
  description = "Map of default tags to apply to resources"

  default = {
    "Project"     = "eks-helm-argocd"
    "Owner"       = "Jovan Zelincevic"
    "Environment" = "dev"
    "Provider"    = "Terraform"
  }
}

variable "region" {
  type        = string
  description = "The region to deploy resources to"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.14.0.0/16"
}

variable "public_subnet_count" {
  type        = number
  description = "Number of public subnets to create"
  default     = 2
}

variable "private_subnet_count" {
  type        = number
  description = "Number of private subnets to create"
  default     = 2
}

# Kubernetes
variable "cluster-context" {
  type    = string
  default = "arn:aws:eks:eu-central-1:223802947597:cluster/eks-jofo-dev"
}
