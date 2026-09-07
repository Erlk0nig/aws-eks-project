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