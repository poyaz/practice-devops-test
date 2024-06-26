download_run_once: ${download_run_once}
download_keep_remote_cache: ${download_keep_remote_cache}
kubeconfig_localhost: true
kubectl_localhost: false
%{ if addresses_in_ssl_keys != "" ~}
supplementary_addresses_in_ssl_keys: ${addresses_in_ssl_keys}
%{ endif ~}

kube_network_plugin: flannel

no_proxy: ""
%{ if http_proxy != "" ~}
http_proxy: "${http_proxy}"
%{ endif ~}
%{ if https_proxy != "" ~}
https_proxy: "${https_proxy}"
%{ endif ~}

%{ if extra_vars_data != "" ~}
${extra_vars_data}
%{ endif ~}
