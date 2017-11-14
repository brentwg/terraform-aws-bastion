# -------------
# Module Inputs
# -------------

# Route53
variable "bastion_zone_id" {
  description = "Bastion DNS hosted zone ID"
  default     = ""
}

variable "bastion_domain_name" {
  description = "Bastion DNS domain name"
  default     = ""
}

variable "bastion_zone_ttl" {
  description = "Bastion zone record set cache time to live (seconds)"
  default     = ""
}

