variable "eks_log_retention_in_days" {
  description = "Retention for EKS control-plane logs."
  type        = number
  default     = 30
}

variable "redis_log_retention_in_days" {
  description = "Retention for Redis engine logs."
  type        = number
  default     = 7
}

variable "postgres_deletion_protection" {
  description = "Protect the Aurora cluster from accidental deletion."
  type        = bool
  default     = false
}

variable "postgres_enabled_cloudwatch_logs_exports" {
  description = "Aurora log types exported to CloudWatch. Manage destination retention externally."
  type        = list(string)
  default     = []
}

variable "alb_ssl_policy" {
  description = "Optional ALB listener security policy; null preserves the controller default."
  type        = string
  default     = null
}

variable "eks_endpoint_public_access" {
  description = "Whether the EKS API has a public endpoint. Ensure Terraform has private connectivity before disabling."
  type        = bool
  default     = true
}

variable "eks_public_access_cidrs" {
  description = "CIDRs allowed to reach the public EKS API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "postgres_ingress_security_group_ids" {
  description = "Security groups allowed to reach PostgreSQL alongside the EKS cluster security group that the Fargate pods carry. null keeps the VPC CIDR rule; any list, even empty, replaces it."
  type        = list(string)
  default     = null
}

variable "redis_ingress_security_group_ids" {
  description = "Security groups allowed to reach Redis alongside the EKS cluster security group that the Fargate pods carry. null keeps the VPC CIDR rule; any list, even empty, replaces it."
  type        = list(string)
  default     = null
}

variable "efs_ingress_security_group_ids" {
  description = "Security groups allowed to reach the ClickHouse EFS mount targets alongside the EKS cluster security group that the Fargate pods carry. null keeps the VPC CIDR rule; any list, even empty, replaces it."
  type        = list(string)
  default     = null
}

variable "eks_api_ingress_security_group_ids" {
  description = "Security groups allowed to reach the Kubernetes API on 443 through aws_security_group.eks. Fargate pods reach the API through the EKS cluster security group and need no entry; include the group Terraform runs from when the endpoint is private. null keeps the VPC CIDR all-TCP rule; any list, even empty, replaces it."
  type        = list(string)
  default     = null
}

variable "alb_ingress_security_group_ids" {
  description = "Security groups allowed to reach the ALB on 80 and 443. When set, the module attaches its own frontend security group through the security-groups annotation and ingress_inbound_cidrs is ignored; the controller keeps managing the shared backend security group. null keeps the controller-managed group built from ingress_inbound_cidrs."
  type        = list(string)
  default     = null

  validation {
    condition     = var.alb_ingress_security_group_ids == null || length(coalesce(var.alb_ingress_security_group_ids, [])) > 0
    error_message = "alb_ingress_security_group_ids must be null or name at least one security group; an empty list would leave the ALB unreachable."
  }
}
