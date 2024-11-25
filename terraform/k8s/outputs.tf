#
# Outputs
#

# namespace
output "namespace" {
  value = local.namespace
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

# basic auth
output "prometheus_basic_auth_username" {
  value = module.kube-prometheus.prometheus_basic_auth_username
}
output "prometheus_basic_auth_password" {
  value = module.kube-prometheus.prometheus_basic_auth_password
}

output "alertmanager_basic_auth_username" {
  value = module.kube-prometheus.alertmanager_basic_auth_username
}
output "alertmanager_basic_auth_password" {
  value = module.kube-prometheus.alertmanager_basic_auth_password
}

output "grafana_basic_auth_username" {
  value = module.kube-prometheus.grafana_basic_auth_username
}
output "grafana_basic_auth_password" {
  value = module.kube-prometheus.grafana_basic_auth_password
}

#output "thanos_basic_auth_username" {
#  value = module.thanos.thanos_basic_auth_username
#}
#output "thanos_basic_auth_password" {
#  value = module.thanos.thanos_basic_auth_password
#}
