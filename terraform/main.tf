module "kubespray_manual" {
  source = "./module/kubespray-manual"

  kubespray_src_path           = var.kubespray_src_path != "" ? var.kubespray_src_path : null
  kubespray_kubeconf_save_path = var.kubespray_kubeconf_save_path != "" ? var.kubespray_kubeconf_save_path : null
  machines                     = var.machines

  kubespray_install_download_run_once          = var.kubespray_install_download_run_once
  kubespray_install_download_keep_remote_cache = var.kubespray_install_download_keep_remote_cache
  kubespray_install_proxy_http                 = var.kubespray_install_proxy_http
  kubespray_install_proxy_https                = var.kubespray_install_proxy_https
  kubespray_install_extra_vars_data            = var.kubespray_install_extra_vars_data
}