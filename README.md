# aws-eks-project

Terraform and GitHub Actions for the first part of the EKS project.

This repository does not deploy the application layer itself. It creates the AWS base infrastructure and the EKS cluster that the second repository builds on.

The second repository installs and configures the tooling layer for the cluster:

- [EKS Tools](https://github.com/Erlk0nig/eks-tools)

## What this repo deploys

- VPC with public and private subnets
- Internet Gateway and NAT Gateways
- Route tables and subnet associations
- Security groups and ingress rules loaded from CSV
- IAM roles for the EKS control plane and worker nodes
- Amazon EKS cluster and managed node group
- EKS access entries for DevOps administrators

## Repository layout

- `main.tf` - root module composition
- `locals.tf` - local values, security group rules, and access entries
- `variables.tf` - input variables for networking and resource naming
- `terraform.tfvars` - environment-specific values for the project
- `sg_rules.csv` - centralized security group ingress definitions
- `modules/network` - VPC, subnets, NAT, route tables, and security groups
- `modules/eks` - EKS cluster, node group, and IAM access configuration
- `backend.tf` - Terraform backend configuration
- `provider.tf` - AWS provider setup

## Prerequisites

- An AWS account with access to create VPC, EKS, IAM, and networking resources
- AWS CLI configured locally
- Terraform installed
- An IAM group named `admins` in the AWS account
- A valid AWS region and project naming configuration

## Configuration

The main variables are defined in `variables.tf` and populated through `terraform.tfvars`.

Key inputs include:

- `fullname` - resource naming prefix
- `cidr_block` - VPC CIDR range
- `public_subnets` - public subnet definitions
- `private_subnets` - private subnet definitions
- `tags` - metadata applied to AWS resources

Security group ingress rules are declared in `sg_rules.csv` and transformed in `locals.tf` for both the public and private security groups.

## Project flow

1. This repository provisions the AWS network, IAM, and EKS cluster.
2. The cluster becomes the foundation for the tooling and application layer in the second repository.
3. The companion repository installs the in-cluster stack, including routing, certificates, and monitoring tools.

## Notes

- This repository provisions the base platform only; it does not deploy workloads or cluster add-ons.
- The second repository extends this environment with the Kubernetes tooling layer.

## About

This project is the infrastructure layer for a two-part EKS setup. The first repository creates the AWS foundation and Kubernetes cluster, while the second repository installs the supporting platform and tools on top of that cluster.
