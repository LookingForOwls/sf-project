# SF Ansible

## Project Structure

- `ansible/`
  - `ansible.cfg`: Ansible configuration file.
  - `main.yml`: Primary playbook for all ansible tasks.
  - `inventory/`: Hosts inventory files, `digital_ocean.yml` creates dynamic inventory using DO API.
  - `load_secrets.sh`: Script to load DO API token as env variable for `digital_ocean.yml`.
  - `requirements.yml`: Lists external Ansible roles or collections to be installed.
  - `roles/`: Custom Ansible roles for configuring servers.
    - Each role (e.g., `common`, `nethermind`, `nimbus`) contains:
      - `files/`: Role-specific files.
      - `tasks/`: Main tasks for the role.
      - `vars/`: Variables specific to the role.
      - `handlers/` and `templates/`: (In certain roles) Handlers and Jinja2 templates for configuration files.
  - `vault-pass.sh`: Script to retrieve the Ansible Vault password using `pass`.

## Prerequisites

- Ansible installed locally.
- Access to `pass` vault containing necessary secrets.
- SSH keys added to the necessary droplets.

## Setup and Deployment

> [!IMPORTANT]  
> Newly created systems must be provisioned in two steps to properly setup passwords from Terraform defaults.

> [!NOTE]  
> Hardening leverages [ansible-collection-hardening](https://github.com/dev-sec/ansible-collection-hardening/tree/master/roles/os_hardening) and takes over 1 hour.

1. **Setup**

    The `pass` vault holds the necessary key for unlocking the Ansible vault and the DO API token.

    Use `./ansible/load_secrets.sh` or another secure method to provide the `DO_API_TOKEN` var. 


2. **Harden Servers and Set Passwords**
    ```
    ansible-playbook -i inventory/ ./playbooks/firstrun.yml --become-password-file ./deploy-pass.sh --connection-password-file ./deploy-pass.sh --vault-password-file ./vault-pass.sh
    ```

3. **Configure Systems**
    ```
     ansible-playbook -i inventory/digital_ocean.yml ./playbooks/main.yml --ask-become-pass --vault-password-file ./vault-pass.sh
    ```

## Security Considerations

Ensure all Ansible secrets are encrypted using `ansible-vault`. 
