download_run_once: true
download_keep_remote_cache: true
kubeconfig_localhost: true
kubectl_localhost: false

kube_network_plugin: flannel

no_proxy: ""
%{ if http_proxy != "" ~}
http_proxy: "${http_proxy}"
%{ endif ~}
%{ if https_proxy != "" ~}
https_proxy: "${https_proxy}"
%{ endif ~}
