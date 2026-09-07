locals {
  env = terraform.workspace
  sg_rules = csvdecode(file("./sg_rules.csv"))

  public_subnet_sg_inbound_rules = {
    for idx, rule in local.sg_rules :
    idx => {
      rule_type = rule["rule_type"]
      protocol  = rule["protocol"]
      from_port = tonumber(split("-", rule["port_range"])[0])
      to_port   = tonumber(split("-", rule["port_range"])[length(split("-", rule["port_range"])) - 1])
      dst_cidr  = rule["dst_cidr"]
      dst_sg    = rule["dst_sg"]
    }
    if rule["sg_name"] == "public_sg" && rule["rule_type"] == "ingress"
  }

  private_subnet_sg_inbound_rules = {
    for idx, rule in local.sg_rules :
    idx => {
      rule_type = rule["rule_type"]
      protocol  = rule["protocol"]
      from_port = tonumber(split("-", rule["port_range"])[0])
      to_port   = tonumber(split("-", rule["port_range"])[length(split("-", rule["port_range"])) - 1])
      dst_cidr  = rule["dst_cidr"]
      dst_sg    = rule["dst_sg"]
    }
    if rule["sg_name"] == "private_sg" && rule["rule_type"] == "ingress"
  }
  devops_users = data.aws_iam_group.admins.users[*].arn
  eks_access_entries_devops = flatten([
    for user_arn in local.devops_users : {
      cluster_name  = "${var.fullname}-${local.env}-eks-cluster"
      principal_arn = user_arn
    }
  ])
}

