COMPOSE_OPTIONS ?=
E2E_TERRAFORM_PROXY ?=
E2E_KUBESPRAY_PROXY ?=

E2E_COMPOSE_EXTRA = -f ./docker/e2e/docker-compose.yml
E2E_COMPOSE_CLI = docker compose -f docker-compose.yml $(COMPOSE_OPTIONS) $(E2E_COMPOSE_EXTRA)
E2E_TERRAFORM_EXEC = $(E2E_COMPOSE_CLI) exec -T terraform sh

define E2E_TERRAFORM_VARS
machines = {
  "master-0" : {
    node_type : "both",
    node_ip : "192.168.121.104",
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

define DOCKER_SCRIPT
docker compose $(COMPOSE_OPTIONS) exec -T terraform sh <<'EOF'
	ls -al
	whoami
	ls /tmp/vars
	cat /tmp/vars
EOF
endef