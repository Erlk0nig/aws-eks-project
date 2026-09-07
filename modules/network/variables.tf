variable "fullname" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "public_subnets" {
    type = list(object({
        cidr_block = string
        availability_zone = string
        name = string
    }))
}

variable "private_subnets" {
    type = list(object({
        cidr_block = string
        availability_zone = string
        name = string
    }))
}

variable "public_subnet_sg_inbound_rules" {
  type = map(object({   
    rule_type = string
    protocol = string
    from_port = number
    to_port = number
    dst_cidr = string
    dst_sg = string
   
  }))
}

variable "private_subnet_sg_inbound_rules" {
  type = map(object({   
    rule_type = string
    protocol = string
    from_port = number
    to_port = number
    dst_cidr = string
    dst_sg = string
   
  }))
}

variable "env" {
  type = string
}