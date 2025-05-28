locals {
  create_eks        = true
  env               = terraform.workspace
  ami_type          = "amazon-linux-2-arm64" # x86 : amazon-linux-2
  eks_pod_role_name = "${var.eks_stage_name}-${var.eks_projet_name}-eks-pod-role"
  eks_managed_policy_list = [
    "AmazonEKSClusterPolicy"
  ]
  eks_node_managed_policy_list = [
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryReadOnly",
    "CloudWatchAgentServerPolicy",
    "AutoScalingFullAccess"
  ]
}

variable "eks_cluster_name" {
  description = "The EKS Cluster name"
  nullable    = false
}

variable "eks_version" {
  description = "the EKS version provided by AWS you want to use"
  nullable    = false
}

variable "eks_cluster_public_subnet_ids" {
  description = "subnet in whitch you want to deploy your cluster. Must be at least on two different availability zones"
  nullable    = false
}

variable "eks_disk_size" {
  description = "Disk size in GiB for worker nodes - by default 20 GB"
  default     = 20
}

variable "eks_ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM, BOTTLEROCKET_ARM_64, BOTTLEROCKET_x86_64"
  #default     = "AL2_ARM_64"
  default = "AL2_x86_64"
}

variable "eks_capacity_type" {
  description = "type of instance :ON_DEMAND or SPOT type"
}

variable "eks_instance_types" {
  type        = list(string)
  description = "List of instance types associated with the EKS Node"
}


variable "eks_node_private_subnet_ids" {
  description = "Subnets id should be used to launch our EKS cluster node"
}

variable "eks_node_group_name" {
  description = "name for the node group definition"
  type        = string
}



variable "eks_min_size_cluster" {
  description = "Minimum number of EC2 instances in our EKS cluster"
}

variable "eks_max_size_cluster" {
  description = "Maximum number of EC2 instances in our EKS cluster"
}

variable "eks_desired_size_cluster" {
  description = "the current size cluster we assume we need for our cluster : effective size when we launch the cluster"
}


variable "eks_projet_name" {
  description = "project name"
  type        = string
}

variable "eks_stage_name" {
  description = "Envrinonment limited to 'prod | dev | test' "
  type        = string
}

variable "eks_common_tags" {
  description = "tag by default for all regarding eks cluster"
  type        = map(string)
  default     = {}
}

variable "eks_account_id" {
  description = "account id where you build your cluster"
  type        = string
}

variable "eks_map_admin_users" {
  type = any
}

variable "env_name" {
  description = "envrinonment name"
  type        = string
}

variable "eks_region" {
  type     = string
  nullable = false
}

variable "enable_spot_request" {
  type = string
}


