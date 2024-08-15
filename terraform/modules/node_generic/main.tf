terraform {
  required_version = ">= 0.13"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

resource "digitalocean_droplet" "generic" {
  name      = var.name
  image     = var.image
  size      = var.size
  region    = var.region
  tags      = var.tag_ids
  vpc_uuid  = var.vpc_uuid
  ipv6 = true
  user_data = templatefile("${path.module}/cloud-init.tftpl", {
    lfo_ssh_key = var.lfo_ssh_key_id
    user_deploy_hash = var.user_deploy_hash
    ssh_config     = var.ssh_config
  })
}

output "droplet_name" {
  value = digitalocean_droplet.generic.name
}

output "ipv4_address_private" {
  value = digitalocean_droplet.generic.ipv4_address_private
}

output "ipv4_address" {
  value = digitalocean_droplet.generic.ipv4_address
}

output "ipv6_address" {
  value = digitalocean_droplet.generic.ipv6_address
}

output "droplet_urn" {
  value = digitalocean_droplet.generic.urn
}

output "droplet_id" {
  value = digitalocean_droplet.generic.id
}

output "droplet_tags" {
  value = digitalocean_droplet.generic.tags
}


resource "digitalocean_project_resources" "sf_resources" {
  project   = var.project_id
  resources = [digitalocean_droplet.generic.urn]
}
