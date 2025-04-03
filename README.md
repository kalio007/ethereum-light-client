# Ethereum Light Node S

This project sets up an Ethereum light node on AWS using Terraform and Ansible.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0+)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.9+)
- AWS CLI configured with appropriate credentials
- SSH key pair registered with AWS

## Setup Instructions

### 1. Configure Terraform Variables

Edit the `terraform/terraform.tfvars` file to match your environment:

```hcl
region           = "us-east-1"  # Your preferred AWS region
key_name         = "your-key-name"  # Your AWS key pair name
private_key_path = "~/.ssh/your-private-key.pem"  # Path to your SSH private key
```

### 2. Initialize and Apply Terraform Configuration

```bash
cd terraform
terraform init
terraform apply
```

Review the planned changes and type `yes` to confirm and create the infrastructure.

### 3. Run Ansible Playbook

After Terraform completes, it will generate an Ansible inventory file. Run the Ansible playbook:

```bash
cd ../ansible
ansible-playbook -i inventory.ini ethereum_node.yml
```

### 4. Verify the Ethereum Node

SSH into your instance:

```bash
ssh -i ~/.ssh/your-private-key.pem ubuntu@<instance-ip>
```

Check the status of the Ethereum service:

```bash
sudo systemctl status geth
```

View the Ethereum logs:

```bash
journalctl -u geth -f
```

## Cleanup

To destroy the infrastructure when no longer needed:

```bash
cd terraform
terraform destroy
```

## Customization

- To modify Ethereum node parameters, edit the Ansible playbook's systemd service definition.
- For different instance types or regions, update the `variables.tf` or `terraform.tfvars` files.

## Resources

    - https://www.hashicorp.com/en/blog/continuous-integration-for-terraform-modules-with-github-actions