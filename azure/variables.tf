variable "tenant_id" {
  description = "The Azure tenant ID to use for the resources."
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription ID to use for the resources."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "Japan East"
}
