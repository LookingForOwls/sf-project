# SF Terraform

This README provides an overview of the Terraform configuration for deploying infrastructure on Digital Ocean.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Prerequisites](#prerequisites)
3. [Setup and Deployment](#setup-and-deployment)

## Project Structure

```
terraform/
├── config_files/
├── firewall.tf
├── main.tf
├── modules/
│   └── node_generic/
├── tf_secrets.sh
└── variables.tf
```

Key components:
- `config_files/`: Directory for configuration files
- `firewall.tf`: Firewall configuration for the infrastructure
- `main.tf`: Main Terraform configuration file
- `modules/`: Directory for Terraform modules
  - `node_generic/`: Module for generic node droplet
- `tf_secrets.sh`: Script for loading Terraform secrets
- `variables.tf`: Variable definitions for the main Terraform configuration

## Prerequisites

- Terraform installed locally
- Access to `pass` vault containing necessary secrets

## Setup and Deployment

Follow these steps to set up and deploy your infrastructure:

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Load Terraform Secret Environment Variables

```bash
source ./tf_secrets.sh
```

### 3. Plan the Deployment

Review the planned changes:

```bash
terraform plan
```

### 4. Apply the Configuration

Deploy your infrastructure:

```bash
terraform apply
```