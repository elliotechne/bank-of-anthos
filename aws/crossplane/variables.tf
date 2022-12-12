variable "region" {
  description = "Region"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "foo" {
  description = "foo"
  type        = string
  default     = "bar"
}
