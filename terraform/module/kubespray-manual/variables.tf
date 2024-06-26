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

variable "kubespray_kubeconf_save_path" {
  type     = string
  default  = "/kubeconf"
  nullable = false
}

variable "machines" {
  description = "Cluster machines"
  type        = map(object({
    node_type = string
    node_ip   = string
    ip        = optional(string)
    access_ip = optional(string)
    ssh       = object({
      port          = number
      username      = string
      password      = string
      sudo_username = optional(string)
      sudo_password = optional(string)
    })
  }))
}

variable "kubespray_install_download_run_once" {
  type     = string
  default  = "false"
  nullable = false
}

variable "kubespray_install_download_keep_remote_cache" {
  type     = string
  default  = "false"
  nullable = false
}

variable "kubespray_install_proxy_http" {
  type     = string
  default  = ""
  nullable = false
}

variable "kubespray_install_proxy_https" {
  type     = string
  default  = ""
  nullable = false
}

variable "kubespray_install_extra_vars_data" {
  type     = string
  default  = ""
  nullable = false
}