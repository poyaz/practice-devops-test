locals {
  list_master_server = {
  for name, machine in var.machines :
  name => {
    node_type : machine.node_type
    node_ip : machine.node_ip
    ip : machine.ip
    ssh : {
      port : machine.ssh.port
      username : machine.ssh.username
      password : replace(machine.ssh.password, "\"", "\\\"")
    }
  }
  if machine.node_type == "master" || machine.node_type == "both"
  }
  list_master_name = {
  for name, machine in var.machines :
  name => name
  if machine.node_type == "master" || machine.node_type == "both"
  }
  list_worker_server = {
  for name, machine in var.machines :
  name => {
    node_type : machine.node_type
    node_ip : machine.node_ip
    ssh : {
      port : machine.ssh.port
      username : machine.ssh.username
      password : replace(machine.ssh.password, "\"", "\\\"")
    }
  }
  if machine.node_type == "worker"
  }
  list_worker_name = {
  for name, machine in var.machines :
  name => name
  if machine.node_type == "worker" || machine.node_type == "both"
  }
}

data "template_file" "inventory" {
  depends_on = [null_resource.kubespray_prepare_installation]
  template   = file("${path.module}/templates/inventory.tpl")
  vars       = {
    connection_strings_master = join(
      "\n",
      formatlist("%s ansible_host=%s ansible_ssh_port=%s ansible_ssh_user=%s ansible_ssh_pass=\"%s\" ansible_become_password=\"%s\" ip=%s access_ip=%s etcd_member_name=etcd%d",
        keys(local.list_master_server),
        values(local.list_master_server).*.node_ip,
        values(local.list_master_server).*.ssh.port,
        values(local.list_master_server).*.ssh.username,
        values(local.list_master_server).*.ssh.password,
        values(local.list_master_server).*.ssh.password,
        values(local.list_master_server).*.ip,
        values(local.list_master_server).*.node_ip,
        range(1, length(local.list_master_server) + 1)
      )
    )
    connection_strings_worker = join(
      "\n",
      formatlist("%s ansible_host=%s ansible_ssh_port=%s ansible_ssh_user=%s ansible_become_password=\"%s\" ansible_sudo_pass=\"%s\" ip=%s access_ip=%s",
        keys(local.list_worker_server),
        values(local.list_worker_server).*.node_ip,
        values(local.list_worker_server).*.ssh.port,
        values(local.list_worker_server).*.ssh.username,
        values(local.list_worker_server).*.ssh.password,
        values(local.list_worker_server).*.ssh.password,
        values(local.list_worker_server).*.ip,
        values(local.list_worker_server).*.node_ip
      )
    )
    label_strings_master = join("\n", keys(local.list_master_name))
    label_strings_worker = join("\n", keys(local.list_worker_name))
  }
}

data "template_file" "vars" {
  depends_on = [null_resource.kubespray_prepare_installation]
  template   = file("${path.module}/templates/vars.tpl")
  vars       = {
    download_run_once          = var.kubespray_install_download_run_once
    download_keep_remote_cache = var.kubespray_install_download_keep_remote_cache
    http_proxy                 = var.kubespray_install_proxy_http
    https_proxy                = var.kubespray_install_proxy_https
    extra_vars_data            = var.kubespray_install_extra_vars_data
  }
}