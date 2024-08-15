# Common rules for templating
locals {
  # Defines outbound rules for common traffic such as HTTP, HTTPS, DNS (TCP and UDP) and NTP
  common_outbound_rules = [
    {
      protocol                = "tcp"
      port_range              = "80"                  # HTTP traffic
      destination_addresses   = ["0.0.0.0/0", "::/0"] # Open to all IPv4 and IPv6 addresses
      destination_droplet_ids = []
    },
    {
      protocol                = "tcp"
      port_range              = "443"                 # HTTPS traffic
      destination_addresses   = ["0.0.0.0/0", "::/0"] # Open to all IPv4 and IPv6 addresses
      destination_droplet_ids = []
    },
    {
      protocol                = "tcp"
      port_range              = "53"                  # DNS traffic over TCP
      destination_addresses   = ["0.0.0.0/0", "::/0"] # Open to all IPv4 and IPv6 addresses
      destination_droplet_ids = []
    },
    {
      protocol                = "udp"
      port_range              = "53"                  # DNS traffic over UDP
      destination_addresses   = ["0.0.0.0/0", "::/0"] # Open to all IPv4 and IPv6 addresses
      destination_droplet_ids = []
    },
    {
      protocol                = "udp"
      port_range              = "123"                 # NTP for time synchronization
      destination_addresses   = ["0.0.0.0/0", "::/0"] # Open to all IPv4 and IPv6 addresses
      destination_droplet_ids = []
    }
  ]

  # Defines common inbound rules for accessing the servers
  common_inbound_rules = [
    {
      protocol           = "tcp"
      port_range         = "22" # SSH for secure remote administration
      source_addresses = ["38.69.197.57"] # Limit SSH to allowlisted IP only. 
    }
  ]
}

# CL Droplet
resource "digitalocean_firewall" "holesky-cl" {
  name = "holesky-cl-firewall"

  droplet_ids = [module.holesky_cl_droplet.droplet_id]

  # Common Inbound
  dynamic "inbound_rule" {
    for_each = local.common_inbound_rules
    content {
      protocol           = inbound_rule.value.protocol
      port_range         = inbound_rule.value.port_range
      source_addresses   = inbound_rule.value.source_addresses
    }
  }

  # Common Outbound
  dynamic "outbound_rule" {
    for_each = local.common_outbound_rules
    content {
      protocol                = outbound_rule.value.protocol
      port_range              = outbound_rule.value.port_range
      destination_addresses   = outbound_rule.value.destination_addresses
      destination_droplet_ids = outbound_rule.value.destination_droplet_ids
    }
  }
}

# EL Droplet
resource "digitalocean_firewall" "holesky-el" {
  name = "holesky-el-firewall"

  droplet_ids = [module.holesky_el_droplet.droplet_id]

  # Common Inbound
  dynamic "inbound_rule" {
    for_each = local.common_inbound_rules
    content {
      protocol           = inbound_rule.value.protocol
      port_range         = inbound_rule.value.port_range
      source_addresses   = inbound_rule.value.source_addresses
    }
  }

  # Common Outbound
  dynamic "outbound_rule" {
    for_each = local.common_outbound_rules
    content {
      protocol                = outbound_rule.value.protocol
      port_range              = outbound_rule.value.port_range
      destination_addresses   = outbound_rule.value.destination_addresses
      destination_droplet_ids = outbound_rule.value.destination_droplet_ids
    }
  }
}