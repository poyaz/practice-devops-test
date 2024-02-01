Introduction
============

This is k8s installation on one single node with git-ops according
to [this task](https://github.com/mason-chase/devops-test)

Design
======

The steps for installing cluster and running services are as follows:

1. First I use Terraform for installing k8s cluster
2. The terraform contains two parts.
   * The first part, is a module for installing the k8s cluster by the Kubespray. It was cloned the Kubespray project and installed all of the dependencies. then execute the ansible command for installation.
   * The second part, install and configure the Flux service in the k8s cluster for using gitops.
3. After installing the Flux successfully, the Flux service fetches all resources for deploying in k8s cluster
4. The resources are as follows
   * The cert-manager for generating the cert
   * The acme-issuer for Let's Encrypt cert
   * The ingress (Haproxy) for the ingress controller and proxy service
   * The OpenEBS for managing local path provisioner
   * The WordPress for installing WordPress, PHPMyAdmin, and Mysql (This is a custom helm chart was written by me)
  
Maybe you ask yourself, why I install ingress and cert-manager with gitops (not using the Kubespray). I prefer installing them with gitops because, in my opinion, it helps to manage and test better in every environment. Or like the ingress service, I prefer using the haproxy. If you ask me, It depends on your idea and your structure to how to use and install services.
Also, for chart same. I prefer to write a custom helm chart for installing and configuring WordPress. The bitnami repo is so good and useful, but i just using my chart to deploy the WordPress.

Requirements
============

This repo has some requirements (based on your environment requirements have been changing)

## Install manually

* make
* terraform
* python3
* Ansible requirements (based on your distro)

## Container

If you like me, love living on the container, you can use docker-compose to run a service with all requirements and dependents
without knowing about them.

* make
* docker (and compose plugin)

How to run
==========

## Docker

The simple way to run in one command, but you should do some flow before executing:

First, you copy `default.tfvars.example` to `product.tfvars` and fill it with your desired environment
Then, you execute the make command

```bash
cp ./terraform/default.tfvars.example ./terraform/product.tfvars

### Or use any text editor you prefer
vim ./terraform/product.tfvars

make run-with-docker
```

If you want to change in compose file and add your config, you can use the directory with the name `./docker/custom/` and
put your compose config in this folder. Then you be able to use the make command with `COMPOSE_OPTIONS`

```bash
cp ./terraform/default.tfvars.example ./terraform/product.tfvars

### Or use any text editor you prefer
vim ./docker/custom/docker-compose.my-config.yml

make run-with-docker COMPOSE_OPTIONS="-f ./docker/custom/docker-compose.my-config.yml"
```

Also, If you have multiplied Terraform vars you be able to use `TERRAFORM_VAR_FILE` in the make command.

```bash
### Or use any text editor you prefer
vim ./terraform/stage.tfvars

make run-with-docker TERRAFORM_VAR_FILE=./terraform/stage.tfvars
```

## Manual

If you prefer to run all commands in your host, you should consider some steps before installing the cluster.

First, you should install requirements based on the Kubespray dependency
Second, you should fill variables `kubespray_src_path` and `kubespray_kubeconf_save_path` in tfvars file

```bash
cp ./terraform/default.tfvars.example ./terraform/product.tfvars

### Or use any text editor you prefer (change **kubespray_src_path** and **kubespray_kubeconf_save_path**)
vim ./terraform/product.tfvars

make run
```

Also, If you have multiplied Terraform vars you be able to use `TERRAFORM_VAR_FILE` in the make command.

```bash
### Or use any text editor you prefer
vim ./terraform/stage.tfvars

make run TERRAFORM_VAR_FILE=./terraform/stage.tfvars
```

Connect to cluster
==================

To connect to the cluster after the installation wizard, we have two ways:

## Docker

After terraform installs the k8s cluster in docker, the kube config yaml file is stored in `./kubeconfig` root folder. You can use this file to connect to the cluster

## Manual

Based on the `kubespray_kubeconf_save_path` the config is stored in this folder.

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

For development and testing, I put the ability to use the e2e test. I use Vagrant to create a machine and test all of these services and commands.

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
