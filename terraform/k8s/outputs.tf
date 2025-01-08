#
# Outputs
#

# namespace
output "namespace" {
  value = var.namespace
}

# kube-prometheus-stack module
output "prometheus_domain_name" {
  value = module.kube-prometheus.prometheus_domain_name
}

output "alertmanager_domain_name" {
  value = module.kube-prometheus.alertmanager_domain_name
}

output "grafana_domain_name" {
  value = module.kube-prometheus.grafana_domain_name
}
output "grafana_cms_to_remove" {
  value = module.kube-prometheus.grafana_cms_to_remove
}

# shared in the different modules
output "stack_monitoring_node_selector" {
  value = module.kube-prometheus.stack_monitoring_node_selector
}

output "extra_labels" {
  value = module.kube-prometheus.extra_labels
}

#output "thanos_install" {
#  value = module.kube-prometheus.thanos_install
#}

# thanos module
#output "thanos_domain_name" {
#  value = module.thanos.thanos_domain_name
#}
#
#output "thanos_bucket" {
#  value = module.thanos.thanos_bucket
#}
#
#output "thanos_bucket_user" {
#  value = module.thanos.thanos_bucket_user
#}

# credentials canonical
output "prometheus_basic_auth_cred_cannonicals" {
  value = module.cycloid-credentials.prometheus_basic_auth_cred_cannonical
}

output "alertmanager_basic_auth_cred_cannonical" {
  value = module.cycloid-credentials.alertmanager_basic_auth_cred_cannonicals
}

output "grafana_basic_auth_cred_cannonical" {
  value = module.cycloid-credentials.grafana_basic_auth_cred_cannonical
}


#output "thanos_basic_auth_username" {
#  value = module.thanos.thanos_basic_auth_username
#}
#output "thanos_basic_auth_password" {
#  value = module.thanos.thanos_basic_auth_password
#}
