resource "aws_eks_access_entry" "devops_access" {
  for_each = {for id, entry in var.eks_access_entries_devops : id => entry   } 

  cluster_name = each.value.cluster_name
  principal_arn = each.value.principal_arn
 
  depends_on = [aws_eks_node_group.eks_node_group]
  
}

resource "aws_eks_access_policy_association" "devops" {
  for_each = {for id, entry in var.eks_access_entries_devops : id => entry   } 

  cluster_name = each.value.cluster_name
  principal_arn = each.value.principal_arn
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  access_scope {
    type = "cluster"
  }
  depends_on = [ aws_eks_access_entry.devops_access]
}
