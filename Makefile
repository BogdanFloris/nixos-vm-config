NIXADDR ?= unset
NIXPORT ?= 22
NIXUSER ?= bogdan
NIXNAME ?= nixos-vm

MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

SSH_OPTIONS=-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no

# Target to copy secrets files to the VM
.PHONY: vm/secrets
vm/secrets:
	@echo "--- Copying secrets files to VM ---"
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--include='id_rsa*' \
		--exclude='*' \
		$(HOME)/.ssh/ $(NIXUSER)@$(NIXADDR):~/.ssh
	@echo "--- Copying complete ---"

# Target to copy configuration files FROM this directory TO the VM
# Destination is /etc/nixos inside the VM
.PHONY: vm/copy
vm/copy:
	@echo "--- Copying configuration files to VM ($(NIXUSER)@$(NIXADDR)) ---"
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='.git/' \
		--exclude='.direnv/' \
		--exclude='result*' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/etc/nixos/
	@echo "--- Copy complete ---"

# Target to apply the configuration INSIDE the VM
# Assumes files have already been copied using vm/copy
.PHONY: vm/switch
vm/switch:
	@echo "--- Applying configuration inside VM ($(NIXUSER)@$(NIXADDR)) ---"
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		sudo nixos-rebuild switch --flake '/etc/nixos#$(NIXNAME)' \
	"
	@echo "--- Switch complete ---"

.PHONY: copy
copy:
	@echo "--- Copying configuration to target directory ---"
	rsync -av \
		--exclude='.git/' \
		--exclude='.direnv/' \
		--exclude='result*' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ /etc/nixos/

.PHONY: switch
switch:
	@echo "--- Applying configuration from inside VM ---"
	sudo nixos-rebuild switch --flake '/etc/nixos#$(NIXNAME)'
	@echo "--- Switch complete ---"

# Convenience target to copy and then switch
.PHONY: vm/update
vm/update: vm/copy vm/switch

# Convenience target to copy secrets and then switch
.PHONY: update
update: copy switch
