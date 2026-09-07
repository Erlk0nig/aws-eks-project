fullname = "aziz-soudani"
cidr_block = "10.0.0.0/16"
tags = {
  "project" : "azure-eks-project",
  "owner"   : "firstname-lastname"
}
public_subnets = [
  {
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    name = "public-subnet-1"
  },
  {
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    name = "public-subnet-2"
  }
]

private_subnets = [
  {
    cidr_block = "10.0.11.0/24"
    availability_zone = "us-east-1a"
    name = "private-subnet-1"
  },
  {
    cidr_block = "10.0.12.0/24"
    availability_zone = "us-east-1b"
    name = "private-subnet-2"
  }
]