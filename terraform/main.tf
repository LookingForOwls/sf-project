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
resource "digitalocean_tag" "sf" {
  name = "sf"
}

resource "digitalocean_tag" "holesky" {
  name = "holesky"
}

resource "digitalocean_tag" "holesky-el" {
  name = "holesky-el"
}

resource "digitalocean_tag" "holesky-cl" {
  name = "holesky-cl"
}

# VPC
resource "digitalocean_vpc" "sf_vpc" {
  name        = "sf-vpc"
  region      = "fra1" # Frankfurt, Germany
  ip_range    = "10.20.0.0/16"
  description = "SF VPC"
}

# Volumes
resource "digitalocean_volume" "cl_vol" {
  region      = "fra1"
  name        = "cl-vol"
  size        = 200
  description = "SF Concensus Client Volume"
  tags        = [digitalocean_tag.sf.id]
}

resource "digitalocean_volume" "el_vol" {
  region      = "fra1"
  name        = "el-vol"
  size        = 200
  description = "SF Execution Client Volume"
  tags        = [digitalocean_tag.sf.id]
}

# Droplets
module "holesky_cl_droplet" {
  source     = "./modules/node_generic"
  name       = "holesky-cl01"
  vpc_uuid   = digitalocean_vpc.sf_vpc.id
  project_id = digitalocean_project.sf_project.id
  tag_ids    = [digitalocean_tag.sf.id, digitalocean_tag.holesky-cl.id, digitalocean_tag.holesky.id]
  # SSH
  lfo_ssh_key_id    = data.digitalocean_ssh_key.lfo_ssh_key.public_key
  ssh_config        = file("${path.module}/config_files/ssh/standard.conf")
  # Set initial user password
  user_deploy_hash = var.user_deploy_hash
}

module "holesky_el_droplet" {
  source     = "./modules/node_generic"
  name       = "holesky-el01"
  vpc_uuid   = digitalocean_vpc.sf_vpc.id
  project_id = digitalocean_project.sf_project.id
  tag_ids    = [digitalocean_tag.sf.id, digitalocean_tag.holesky-el.id, digitalocean_tag.holesky.id]
  # SSH
  lfo_ssh_key_id    = data.digitalocean_ssh_key.lfo_ssh_key.public_key
  ssh_config        = file("${path.module}/config_files/ssh/standard.conf")
  # Set initial user password
  user_deploy_hash = var.user_deploy_hash
}

# Attach Volumes
resource "digitalocean_volume_attachment" "cl-client" {
  droplet_id = module.holesky_cl_droplet.droplet_id
  volume_id  = digitalocean_volume.cl_vol.id
}

resource "digitalocean_volume_attachment" "el-client" {
  droplet_id = module.holesky_el_droplet.droplet_id
  volume_id  = digitalocean_volume.el_vol.id
}

