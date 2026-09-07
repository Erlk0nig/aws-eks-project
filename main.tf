module "network" {
  source = "./modules/network"
  cidr_block                       = var.cidr_block
  public_subnets                   = var.public_subnets
  private_subnets                  = var.private_subnets
  public_subnet_sg_inbound_rules   = local.public_subnet_sg_inbound_rules
  private_subnet_sg_inbound_rules  = local.private_subnet_sg_inbound_rules
  fullname                         = var.fullname
  env                              = local.env
}

data "aws_iam_group" "admins" {
  group_name = "admins"
}

module "eks" {
  source = "./modules/eks"

  env                    = local.env
  fullname               = var.fullname
  tags                   = var.tags
  private_subnet_ids     = module.network.private_subnet_ids
  eks_access_entries_devops = local.eks_access_entries_devops
  depends_on = [module.network, data.aws_iam_group.admins]
}  