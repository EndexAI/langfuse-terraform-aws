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
