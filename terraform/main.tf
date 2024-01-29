module "kubespray_manual" {
  source = "./module/kubespray-manual"

  kubespray_src_path            = var.kubespray_src_path != "" ? var.kubespray_src_path : null
  machines                      = var.machines
  kubespray_install_proxy_http  = var.kubespray_install_proxy_http
  kubespray_install_proxy_https = var.kubespray_install_proxy_https
}