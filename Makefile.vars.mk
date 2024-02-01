COMPOSE_OPTIONS ?=
E2E_TERRAFORM_PROXY ?=
E2E_KUBESPRAY_PROXY ?=

E2E_COMPOSE_EXTRA = -f ./docker/e2e/docker-compose.yml
E2E_COMPOSE_CLI = docker compose -f docker-compose.yml $(COMPOSE_OPTIONS) $(E2E_COMPOSE_EXTRA)

COMPOSE_CLI = docker compose -f docker-compose.yml $(COMPOSE_OPTIONS)
COMPOSE_RUN_SERVICE = run --rm --entrypoint '' -T terraform sh

TERRAFORM_VAR_FILE = ./product.tfvars

define E2E_TERRAFORM_VARS
machines = {
  "master-0" : {
    node_type : "both",
    node_ip : "$(VAGRANT_SERVER_IP)",
    ssh : {
      port     = 22
      username = "vagrant"
      password = "vagrant"
    }
  }
}

endef
ifneq ($(E2E_KUBESPRAY_PROXY),)
E2E_TERRAFORM_VARS := $(E2E_TERRAFORM_VARS)\nkubespray_install_proxy_http = "$(E2E_KUBESPRAY_PROXY)"
E2E_TERRAFORM_VARS := $(E2E_TERRAFORM_VARS)\nubespray_install_proxy_https = "$(E2E_KUBESPRAY_PROXY)"
endif

define E2E_DOCKER_EXEC
E2E_NO_PROXY=$(VAGRANT_SERVER_IP) $(E2E_COMPOSE_CLI) $(COMPOSE_RUN_SERVICE) <<'EOF'
	terraform init --upgrade
	terraform plan -var-file /tmp/vars/testing.tfvars
	terraform apply -var-file /tmp/vars/testing.tfvars -auto-approve
EOF
endef

define DOCKER_EXEC
$(COMPOSE_CLI) $(COMPOSE_RUN_SERVICE) <<'EOF'
	terraform init --upgrade
	terraform plan -var-file $(TERRAFORM_VAR_FILE)
	terraform apply -var-file $(TERRAFORM_VAR_FILE) -auto-approve
EOF
endef
