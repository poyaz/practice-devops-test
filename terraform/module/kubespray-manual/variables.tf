variable "kubespray_src_path" {
  type     = string
  default  = "/srv/kubespray"
  nullable = false
}

variable "kubespray_virtualenv_name" {
  type    = string
  default = ".kubespray"
}

variable "kubespray_virtualenv_activate_path" {
  type    = string
  default = "bin/activate"
}

variable "kubespray_git_repo" {
  type    = string
  default = "https://github.com/kubernetes-sigs/kubespray"
}

variable "kubespray_git_depth" {
  type    = string
  default = "1"
}

variable "kubespray_inventory_folder" {
  type    = string
  default = "inventory/k8s-test"
}

variable "machines" {
  description = "Cluster machines"
  type        = map(object({
    node_type = string
    node_ip   = string
    ssh       = object({
      port     = number
      username = string
      password = string
    })
  }))
}

variable "kubespray_install_proxy_http" {
  type = string
  default = ""
  nullable = false
}

variable "kubespray_install_proxy_https" {
  type = string
  default = ""
  nullable = false
}