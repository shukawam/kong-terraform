variable "client_id" {
  description = "The Azure application ID to use for the resources."
  type        = string
}

variable "client_secret" {
  description = "The client secret for the Azure application."
  type        = string
  sensitive   = true
}

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

variable "kong_cluster_cert" {
  description = "The Konnect certification"
  type        = string
  sensitive   = true
}

variable "kong_cluster_cert_key" {
  description = "The Konnect private key"
  type        = string
  sensitive   = true
}
