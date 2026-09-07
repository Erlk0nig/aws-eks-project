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