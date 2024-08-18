# SF Example Infrastructure Assignment

This repository contains Terraform and Ansible code for deploying and configuring Ethereum clients on Digital Ocean.

## Overview

- **Execution Client:** Nethermind
- **Consensus Client:** Nimbus
- **Cloud Provider:** Digital Ocean

## Infrastructure Components

Terraform manages the following resources:
- DigitalOcean project
- VPC
- Firewall rules
- Tags
- Volumes
- Droplets

## Configuration

Ansible handles:
- Installation of necessary OS packages
- Configuration of Ethereum clients
- Ethereum client updates

## Documentation

For detailed information on setup and usage:
- [Terraform Documentation](./terraform/README.md)
- [Ansible Documentation](./ansible/README.md)

## Getting Started

1. Clone this repository
2. Follow the setup instructions in the Terraform and Ansible documentation
3. Deploy your infrastructure and configure your Ethereum clients
