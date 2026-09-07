variable "env" {
  description = "Environment name"
  type        = string  
}

variable "fullname" {
  description = "Full name for resources"
  type        = string  
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)  
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "eks_access_entries_devops" {
  description = "List of access entries for DevOps users"
  type        = list(object({
    cluster_name   = string
    principal_arn  = string
  }))  
}