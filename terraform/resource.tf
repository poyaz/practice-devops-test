resource "flux_bootstrap_git" "gitops" {
  depends_on = [module.kubespray_manual]
  path       = "ops/cluster"
}