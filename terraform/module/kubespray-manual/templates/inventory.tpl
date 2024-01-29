[all]
${connection_strings_master}
${connection_strings_worker}

[kube_control_plane]
${label_strings_master}

[etcd]
${label_strings_master}

[kube_node]
${label_strings_worker}

[k8s_cluster:children]
kube_control_plane
kube_node