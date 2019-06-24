variable "cp_om_ipv4_address" {
  type = "string"
}

variable "cp_om_internal_ipv4_address" {
  type = "string"
}

variable "control_plane_cidr" {
  type = "string"
}

variable "control_plane_snat_ip" {
  type = "string"
}

variable "control_plane_gateway" {
  type = "string"
}

variable "allow_unverified_ssl" {
  default = false
  type    = "string"
}

variable "nsxt_host" {
  default     = ""
  description = "The nsx-t host."
  type        = "string"
}

variable "nsxt_username" {
  default     = ""
  description = "The nsx-t username."
  type        = "string"
}

variable "nsxt_password" {
  default     = ""
  description = "The nsx-t password."
  type        = "string"
}

variable "nsxt_transport_zone" {
  default     = ""
  description = "The name of the overlay transport zone."
  type        = "string"
}

variable "nsxt_edge_cluster" {
  default     = ""
  description = "The name of the edge cluster."
  type        = "string"
}

variable "nsxt_t0_router" {
  default     = ""
  description = "The name of the logical tier 0 router."
  type        = "string"
}

variable "concourse_vip_server" {
  default     = ""
  description = "IP Address for concourse loadbalancer"
  type        = "string"
}

variable "minio_vip_server" {
  default     = ""
  description = "IP Address for minio loadbalancer"
  type        = "string"
}