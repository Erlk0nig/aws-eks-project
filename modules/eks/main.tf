resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.fullname}-${var.env}-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn 
  version = "1.35"
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  vpc_config {
    subnet_ids = var.private_subnet_ids
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.fullname}-${var.env}-spot-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn 
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.medium", "t3.medium"]
  disk_size      = 20
  capacity_type = "SPOT"

  tags = {
    Name = "eks-spot-node-group"
  }
  depends_on = [ aws_eks_cluster.eks_cluster ]
}
