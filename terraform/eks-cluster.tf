module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.29.0"

cluster_name = "myapp-eks-cluster"
cluster_version = "1.31"
cluster_endpoint_public_access = true

subnet_ids = module.myapp-vpc.private_subnets
vpc_id = module.myapp-vpc.vpc_id

tags = {
    environment = "developemnt"
    application = "myapp"
}

eks_managed_node_groups = {
    dev = {

        min_size     = 2
        max_size     = 3
        desired_size = 2

         instance_types = ["t2.small"]

    }
  }
}

