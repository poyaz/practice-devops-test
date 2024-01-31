variable "enable_test" {
  type    = bool
  default = false
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

variable "kubespray_src_path" {
  type    = string
  default = null
}

variable "kubespray_kubeconf_save_path" {
  type    = string
  default = null
}

variable "kubespray_install_download_run_once" {
  type    = string
  default = null
}

variable "kubespray_install_download_keep_remote_cache" {
  type    = string
  default = null
}

variable "kubespray_install_proxy_http" {
  type    = string
  default = null
}

variable "kubespray_install_proxy_https" {
  type    = string
  default = null
}

variable "kubespray_install_extra_vars_data" {
  type    = string
  default = null
}

variable "flux_git_repo" {
  type    = string
  default = "https://github.com/poyaz/practice-devops-test.git"
}

variable "flux_git_branch" {
  type    = string
  default = "main"
}

variable "flux_git_http_auth" {
  type = object({
    username = string
    password = string
  })
}