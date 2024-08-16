# Provider setup
terraform {
  required_version = ">= 0.13"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

# Project
resource "digitalocean_project" "sf_project" {
  name        = "sf_test"
  description = "Node SaaS"
  purpose     = "Staking Application"
  environment = "Production"
}

# Tags
variable "tags" {
  type    = set(string)
  default = ["sf", "holesky", "holesky-el", "holesky-cl"]
}

resource "digitalocean_tag" "tags" {
  for_each = var.tags
  name     = each.value
}

# VPC
resource "digitalocean_vpc" "sf_vpc" {
  name        = "sf-vpc"
  region      = "fra1" # Frankfurt, Germany
  ip_range    = "10.20.0.0/16"
  description = "SF VPC"
}

# Droplets
module "holesky_cl_droplet" {
  source     = "./modules/node_generic"
  name       = "holesky-cl01"
  vpc_uuid   = digitalocean_vpc.sf_vpc.id
  project_id = digitalocean_project.sf_project.id
  tag_ids = [
    digitalocean_tag.tags["sf"].id,
    digitalocean_tag.tags["holesky"].id,
    digitalocean_tag.tags["holesky-cl"].id
  ]
  # SSH
  lfo_ssh_key_id = data.digitalocean_ssh_key.lfo_ssh_key.public_key
  ssh_config     = file("${path.module}/config_files/ssh/standard.conf")
  # Set initial user password
  user_deploy_hash = var.user_deploy_hash
}

module "holesky_el_droplet" {
  source     = "./modules/node_generic"
  name       = "holesky-el01"
  vpc_uuid   = digitalocean_vpc.sf_vpc.id
  project_id = digitalocean_project.sf_project.id
  tag_ids = [
    digitalocean_tag.tags["sf"].id,
    digitalocean_tag.tags["holesky"].id,
    digitalocean_tag.tags["holesky-el"].id
  ]
  # SSH
  lfo_ssh_key_id = data.digitalocean_ssh_key.lfo_ssh_key.public_key
  ssh_config     = file("${path.module}/config_files/ssh/standard.conf")
  # Set initial user password
  user_deploy_hash = var.user_deploy_hash
}

# Volumes and Attachments
resource "digitalocean_volume" "holesky_vols" {
  for_each = {
    "holesky-cl01-vol" = "SF Consensus Client Volume"
    "holesky-el01-vol" = "SF Execution Client Volume"
  }
  region      = "fra1" # Make sure this matches your droplets' region
  name        = each.key
  size        = 200
  description = each.value
  tags        = [digitalocean_tag.tags["sf"].id]
}

# Volume Attachments
resource "digitalocean_volume_attachment" "holesky_cl_attachment" {
  droplet_id = module.holesky_cl_droplet.droplet_id
  volume_id  = digitalocean_volume.holesky_vols["holesky-cl01-vol"].id
}

resource "digitalocean_volume_attachment" "holesky_el_attachment" {
  droplet_id = module.holesky_el_droplet.droplet_id
  volume_id  = digitalocean_volume.holesky_vols["holesky-el01-vol"].id
}
