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

variable "user_id" {
  description = "The Azure user ID to use for the resources."
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "Japan East"
}

variable "kong_cluster_control_plane" {
  description = "The Konnect control plane"
  type        = string
}

variable "kong_cluster_server_name" {
  description = "The Konnect server name"
  type        = string
}

variable "kong_cluster_telemetry_endpoint" {
  description = "The Konnect telemetry endpoint"
  type        = string
}

variable "kong_cluster_telemetry_server_name" {
  description = "The Konnect telemetry server name"
  type        = string
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
