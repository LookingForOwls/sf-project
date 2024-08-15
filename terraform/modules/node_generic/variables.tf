# Droplet Vars
variable "name" {
  description = "Name of the droplet"
  type        = string
}

variable "image" {
  description = "Droplet image"
  type        = string
  default     = "debian-12-x64"
}

variable "size" {
  description = "Droplet size"
  type        = string
  default     = "s-4vcpu-16gb-amd"
}

variable "region" {
  description = "Droplet region"
  type        = string
  default = "fra1"
}

variable "vpc_uuid" {
  description = "VPC UUID where the droplet will be created"
  type        = string
}

variable "project_id" {
  description = "Project ID"
  type = string
}

variable "tag_ids" {
  description = "Droplet tag ID"
  type        = list(string)
}

variable "user_data" {
  description = "User data for cloud-init script"
  type        = string
  default     = "# Cloud-init script goes here"
}

# User Vars
variable "lfo_ssh_key_id" {
  description = "SSH Key ID for LFO"
  type        = string
}

# Sensitive
variable "user_deploy_hash" {
  description = "Password for the user"
  sensitive = true
}

# Config vars
variable "ssh_config" {
  description = "The content of the SSH configuration file."
  type        = string
}
