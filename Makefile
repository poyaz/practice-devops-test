include Makefile.vars.mk

export E2E_TERRAFORM_VARS
export E2E_DOCKER_EXEC
export DOCKER_EXEC

.PHONY: build-image
build-image:
	docker compose -f docker-compose.yml $(COMPOSE_OPTIONS) build

.PHONY: test-run
test-run: build-image
test-run:
	vagrant up
	$(eval VAGRANT_SERVER_IP=$(shell vagrant ssh-config k8s-test | grep HostName | cut -d' ' -f4))
	echo $(VAGRANT_SERVER_IP)

	rm -rf $(PWD)/tmp/e2e/vars
	mkdir -p $(PWD)/tmp/e2e/vars

	echo -e "$$E2E_TERRAFORM_VARS" > $(PWD)/tmp/e2e/vars/testing.tfvars

	eval "$$E2E_DOCKER_EXEC"

.PHONY: test-stop
test-stop:
	vagrant halt

.PHONY: test-clear
test-clear:
	vagrant destroy --parallel --force

.PHONY: run
run:
	cd ./terraform
	terraform init --upgrade
	terraform plan -var-file $(TERRAFORM_VAR_FILE)
	terraform apply -var-file $(TERRAFORM_VAR_FILE) -auto-approve

.PHONY: run-with-docker
run-with-docker: build-image
run-with-docker:
	eval "$$DOCKER_EXEC"
