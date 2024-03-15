variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "do_destroy" {
  description = "Indicates whether to destroy the infrastructure"
  type        = bool
  default     = true
}
