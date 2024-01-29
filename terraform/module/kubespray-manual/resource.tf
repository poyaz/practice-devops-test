resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    command     = "git clone ${var.kubespray_git_repo} --depth ${var.kubespray_git_depth} --branch v2.23.2 ${var.kubespray_src_path}"
    interpreter = ["sh", "-c"]
  }
}

resource "null_resource" "kubespray_pip_install" {
  depends_on = [module.kubespray_virtualenv_path, null_resource.git_clone]
  provisioner "local-exec" {
    command     = <<EOF
      cd ${var.kubespray_src_path}
      virtualenv ${var.kubespray_virtualenv_name}
      source ${module.kubespray_virtualenv_path.path}
      pip3 install --no-compile \
       ansible==7.6.0 \
       ansible-core==2.14.6 \
       cryptography==41.0.1 \
       jinja2==3.1.2 \
       netaddr==0.8.0 \
       jmespath==1.0.1 \
       MarkupSafe==2.1.3 \
       ruamel.yaml==0.17.21 \
       passlib==1.7.4
    EOF
    interpreter = ["sh", "-c"]
  }
}

resource "null_resource" "kubespray_prepare_installation" {
  depends_on = [null_resource.kubespray_pip_install]
  provisioner "local-exec" {
    command     = <<EOF
      cd ${var.kubespray_src_path}
      cp -rfp inventory/sample ${var.kubespray_inventory_folder}
    EOF
    interpreter = ["sh", "-c"]
  }
}

resource "null_resource" "kubespray_create_inventory" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ${module.kubespray_ansible_inventory.path}"
  }

  triggers = {
    template = data.template_file.inventory.rendered
  }
}

resource "null_resource" "kubespray_create_vars" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.vars.rendered}' > ${module.kubespray_ansible_vars.path}"
  }

  triggers = {
    template = data.template_file.vars.rendered
  }
}

resource "null_resource" "kubespray_ansible_install" {
  depends_on = [null_resource.kubespray_create_inventory]
  provisioner "local-exec" {
    command     = <<EOF
      cd ${var.kubespray_src_path}
      source ${module.kubespray_virtualenv_path.path}
      ansible-playbook -i ${module.kubespray_ansible_inventory.path} --become --become-user=root cluster.yml -e @${module.kubespray_ansible_vars.path}
    EOF
    interpreter = ["sh", "-c"]
  }
}