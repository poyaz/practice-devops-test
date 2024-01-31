Introduction
============

This is k8s installation on one single node with git-ops according
to [this task](https://github.com/mason-chase/devops-test)

Requirements
============

This repo has some requirements (base on your environment requirements have been changing)

## Install manually

* make
* terraform
* python3
* Ansible requirements (base on your distro)

## Container

If you like me, love live on container, you can use docker-compose to run service with all requirements and dependents
without knows about them.

* make
* docker (and compose plugin)

How to run
==========

## Docker

The simple way for run in one command, but you should do some flow before execute:

First, you copy `default.tfvars.example` to `product.tfvars` and fill it with your desire environment
Then, you execute the make command

```bash
cp ./terraform/default.tfvars.example ./terraform/product.tfvars

### Or use any text editor you prefer
vim ./terraform/product.tfvars

make run-with-docker
```

If you want change in compose file and add your own config, you cna use the directory with name `./docker/custom/` and
put your compose config in this folder. Ten you be able to use in the make command with `COMPOSE_OPTIONS`

```bash
cp ./terraform/default.tfvars.example ./terraform/product.tfvars

### Or use any text editor you prefer
vim ./docker/custom/docker-compose.my-config.yml

make run-with-docker COMPOSE_OPTIONS="-f ./docker/custom/docker-compose.my-config.yml"
```

Also, If you have multiply Terraform vars you be able to use `TERRAFORM_VAR_FILE` in make command.

```bash
### Or use any text editor you prefer
vim ./terraform/stage.tfvars

make run-with-docker TERRAFORM_VAR_FILE=./terraform/stage.tfvars
```

## Manual

If you prefer run all commands in your host, you should consider some steps before install cluster.

First, you should install requirements base on kubespray dependency
Second, you should fill variables `kubespray_src_path` and `kubespray_kubeconf_save_path` in tfvars file

```bash
cp ./terraform/default.tfvars.example ./terraform/product.tfvars

### Or use any text editor you prefer (change **kubespray_src_path** and **kubespray_kubeconf_save_path**)
vim ./terraform/product.tfvars

make run
```

Also, If you have multiply Terraform vars you be able to use `TERRAFORM_VAR_FILE` in make command.

```bash
### Or use any text editor you prefer
vim ./terraform/stage.tfvars

make run TERRAFORM_VAR_FILE=./terraform/stage.tfvars
```

Connect to cluster
==================

For connect to cluster after installation wizard, we have two ways:

## Docker

After terraform install k8s cluster in docker, the kube config yaml file store in `./kubeconfig` root folder. You can use this file for connect to cluster

## Manual

Base on the `kubespray_kubeconf_save_path` the config store in this folder.

--------

```bash
### Mysql root password
KUBECONFIG=./kubeconf/admin.conf kubectl --namespace wordpress get secret mysql-root-pass -o jsonpath='{.data.password}' | base64 -d

### Wordpress auth
KUBECONFIG=./kubeconf/admin.conf kubectl --namespace wordpress get secret wp-auth -o jsonpath='{.data.username}' | base64 -d
KUBECONFIG=./kubeconf/admin.conf kubectl --namespace wordpress get secret wp-auth -o jsonpath='{.data.password}' | base64 -d
```

Development
===========

For development and test, I put ability to use e2e test. I use Vagrant to create machine and test all of these service and command.

Requirements:

* Make
* Libvirt
* Vagrant
* Docker (with compose plugin)

```bash
### For run test
make test-run

### Stop machine
make test-stop

### Clear all test
make test-clear
```