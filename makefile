include .env


# Default target
all: deploy

# Deploy the Ethereum node using provided Ansible command
ansible:
	ansible-playbook -i ../terraform/inventory.ini ethereum_node.yml --private-key=$(SSH_KEY_PATH)

# SSH into the Ethereum node
ssh:
	ssh -i $(SSH_KEY_PATH) $(SSH_USER)@$(ETHEREUM_NODE_IP)

# Check the status of the Ethereum node
status:
	ssh -i $(SSH_KEY_PATH) $(SSH_USER)@$(ETHEREUM_NODE_IP) "systemctl status geth"

# View the logs of the Ethereum node
logs:
	ssh -i $(SSH_KEY_PATH) $(SSH_USER)@$(ETHEREUM_NODE_IP) "journalctl -u geth -n 50"

# Print the connection information
info:
	@echo "Ethereum Node IP: $(ETHEREUM_NODE_IP)"
	@echo "SSH User: $(SSH_USER)"
	@echo "SSH Key Path: $(SSH_KEY_PATH)"