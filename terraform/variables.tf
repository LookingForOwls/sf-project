variable "do_token" {
  description = "Digital Ocean API token"
  type        = string
  sensitive   = true
}

variable "user_deploy_hash" {
  description = "Initial password for the user"
  sensitive   = true
}

data "digitalocean_ssh_key" "lfo_ssh_key" {
  name = "LFO"
}