module "kubespray_virtualenv_path" {
  source = "git::https://github.com/gruntwork-io/terraform-aws-utilities.git//modules/join-path?ref=v0.9.6"

  path_parts = [var.kubespray_src_path, var.kubespray_virtualenv_name, var.kubespray_virtualenv_activate_path]
}

module "kubespray_ansible_inventory" {
  source = "git::https://github.com/gruntwork-io/terraform-aws-utilities.git//modules/join-path?ref=v0.9.6"

  path_parts = [var.kubespray_src_path, var.kubespray_inventory_folder, "inventory.ini"]
}

module "kubespray_ansible_vars" {
  source = "git::https://github.com/gruntwork-io/terraform-aws-utilities.git//modules/join-path?ref=v0.9.6"

  path_parts = [var.kubespray_src_path, var.kubespray_inventory_folder, "vars.yml"]
}

module "kubespray_kube_config" {
  source = "git::https://github.com/gruntwork-io/terraform-aws-utilities.git//modules/join-path?ref=v0.9.6"

  path_parts = [var.kubespray_src_path, var.kubespray_inventory_folder, "artifacts", "admin.conf"]
}