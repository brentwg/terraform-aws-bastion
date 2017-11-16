# -------------
# Module Inputs
# -------------
variable "customer_name" {
  description = "The name of the customer"
  default     = ""
}

variable "environment" {
  description = "The development environment (dev, test, prod...)"
  default     = ""
}

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

# ASG Launch Configuration
variable "bastion_region" {
  description = "Bastion AWS region"
  default     = ""
}

variable "bastion_image_id" {
  description = "Bastion AMI image ID"
  default     = ""
}

variable "bastion_instance_type" {
  description = "Bastion instance type"
  default     = ""
}

variable "bastion_key_name" {
  description = "Bastion SSH key pair name"
  default     = ""
}

variable "bastion_security_groups" {
  description = "Bastion security group list"
  type        = "list"
  default     = []
}

variable "bastion_user_data_script" {
  description = "Bastion user data bootstrap script"
  default     = ""
}

variable "bastion_ebs_optimized" {
  description = "Bastion EBS optimized (true/false)"
  default     = "false"
}

variable "bastion_enable_monitoring" {
  description = "Bastion enable detailed monitoring (true/false)"
  default     = "false"
}

variable "bastion_volume_type" {
  description = "Bastion root volume type"
  default     = ""
}

variable "bastion_volume_size" {
  description = "Bastion root volume size (GB)"
  default     = ""
}

# ASG
variable "bastion_max_size" {
  description = "Bastion ASG maximum size"
  default     = "1"
}

variable "bastion_min_size" {
  description = "Bastion ASG minimum size"
  default     = "1"
}

variable "bastion_desired_capacity" {
  description = "Bastion ASG desired size"
  default     = "1"
}

variable "bastion_asg_subnets" {
  description = "List of subnet IDs to launch Bastion in"
  type        = "list"
  default     = []
}
