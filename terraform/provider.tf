provider "flux" {
  kubernetes = {
    config_path = module.kubespray_manual.kube_conf
  }
  git = {
    url    = var.flux_git_repo
    branch = var.flux_git_branch
    http = {
      username = var.flux_git_http_auth.username
      password = var.flux_git_http_auth.password
    }
  }
}