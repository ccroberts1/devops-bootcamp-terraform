module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name = var.cluster_name
  cluster_version = "1.27"

  cluster_addons = {
    aws-ebs-csi-driver = {}
  }

  cluster_endpoint_public_acces = true

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  tags = {
    environment = var.env_prefix
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.small"]
    }
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
  }
}
