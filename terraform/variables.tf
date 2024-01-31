variable "machines" {
  description = "Cluster machines"
  type = map(object({
    node_type = string
    node_ip   = string
    ip        = optional(string)
    access_ip = optional(string)
    ssh = object({
      port          = number
      username      = string
      password      = string
      sudo_username = optional(string)
      sudo_password = optional(string)
    })
  }))
}

variable "kubespray_src_path" {
  description = "The git path of kubespray"
  type        = string
  default     = null
}

variable "kubespray_kubeconf_save_path" {
  description = "The k8s config yaml file store in this path"
  type        = string
  default     = null
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
  description = "The http proxy address use for install k8s"
  type        = string
  default     = null
}

variable "kubespray_install_proxy_https" {
  description = "The https proxy address use for install k8s"
  type        = string
  default     = null
}

variable "kubespray_install_extra_vars_data" {
  description = "The more extra vars base on kubespray vars"
  type        = string
  default     = null
}

variable "flux_git_repo" {
  description = "The address of git for use in git-ops"
  type        = string
  default     = "https://github.com/poyaz/practice-devops-test.git"
}

variable "flux_git_branch" {
  description = "Git repository branch use in flux"
  type        = string
  default     = "main"
}

variable "flux_git_http_auth" {
  description = "The Github authentication"
  type = object({
    username = string
    password = string
  })
}