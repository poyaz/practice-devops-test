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