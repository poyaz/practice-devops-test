include Makefile.vars.mk

export E2E_TERRAFORM_VARS
export DOCKER_SCRIPT

.PHONY: build-image
build-image:
	docker compose $(COMPOSE_OPTIONS) build

.PHONY: test-run
#test-run: build-image
test-run:
	vagrant up
	$(eval VAGRANT_SERVER_IP=$(shell vagrant ssh-config k8s-test | grep HostName | cut -d' ' -f4))
	echo $(VAGRANT_SERVER_IP)

	rm -rf $(PWD)/tmp/e2e/vars
	mkdir -p $(PWD)/tmp/e2e/vars

	echo -e "$$E2E_TERRAFORM_VARS" > $(PWD)/tmp/e2e/vars/testing.tfvars

	eval "$$DOCKER_SCRIPT"

.PHONY: test-stop
test-stop:
	vagrant halt

.PHONY: test-clear
test-clear:
	vagrant destroy --parallel --force
