# SF Ansible

This README provides an overview of the Ansible configuration for deploying and managing Ethereum clients on Digital Ocean.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Prerequisites](#prerequisites)
3. [Setup and Deployment](#setup-and-deployment)
4. [Client Upgrades](#client-upgrades)

## Project Structure

```
ansible/
├── ansible.cfg
├── main.yml
├── firstrun.yml
├── update-clients.yml
├── inventory/
├── group_vars/
├── playbooks/
├── scripts/
├── requirements.yml
└── roles/
    ├── blockstorage/
    ├── common/
    ├── consensys.nimbus/
    ├── nethermind/
    └── nimbus/
```

Key components:
- `main.yml`: Primary playbook for client setup tasks
- `firstrun.yml`: Playbook for initial setup tasks
- `update-clients.yml`: Playbook for updating client software
- `inventory/`: Dynamic inventory for Digital Ocean
- `roles/`: Custom Ansible roles for server configuration

## Prerequisites

- Ansible installed locally
- Access to `pass` vault containing necessary secrets
- SSH keys added to the necessary droplets

## Setup and Deployment

> [!IMPORTANT]  
> Newly created systems must be provisioned in two steps to properly setup passwords from Terraform defaults.

### 1. Setup

The `pass` vault holds the necessary key for unlocking the Ansible vault and the DO API token.

```bash
source ./ansible/scripts/load_secrets.sh
```

### 2. Initial Setup and Set Passwords

Run this playbook once after initial Terraform provisioning:

```bash
ansible-playbook -i inventory/digital_ocean.yml firstrun.yml --become-password-file ./scripts/deploy-pass.sh --vault-password-file ./scripts/vault-pass.sh
```

### 3. Configure Systems

Install and configure the Nethermind and Nimbus clients:

```bash
ansible-playbook -i inventory/digital_ocean.yml main.yml --ask-become-pass --vault-password-file ./scripts/vault-pass.sh
```
> [!NOTE]  
> All install variables can be found in `group_vars`. Verify the default client versions are correct.

## Client Upgrades

Update client software and service files using the `update-clients.yml` playbook:

```bash
ansible-playbook -i inventory/digital_ocean.yml update-clients.yml --ask-become-pass --vault-password-file ./scripts/vault-pass.sh
```

This playbook:
- Updates clients only if necessary based on `nm_version` and `nimbus_version` variables
- Uses the JSON-RPC API to verify the client is UP and the desired version is running
