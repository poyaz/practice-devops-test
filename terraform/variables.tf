variable "enable_test" {
  type    = bool
  default = false
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

variable "kubespray_src_path" {
  type    = string
  default = null
}

variable "kubespray_install_proxy_http" {
  type = string
}

variable "kubespray_install_proxy_https" {
  type = string
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