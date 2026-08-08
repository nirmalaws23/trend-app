# Provider Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1. Jenkins EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami           = "ami-0c555d2d7d0196220" # Replace with your target AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-Server"
  }
}

# 2. EKS Cluster Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "trend-app-cluster"
  cluster_version = "1.27"

  vpc_id     = "vpc-xxxxxxxx" # Replace with your VPC ID
  subnet_ids = ["subnet-xxxxxxx1", "subnet-xxxxxxx2"] # Replace with your Subnet IDs

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
    }
  }
}