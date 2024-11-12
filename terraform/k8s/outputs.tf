#
# Outputs
#

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


output "stack_monitoring_node_selector" {
  value = module.kube-prometheus.stack_monitoring_node_selector
}

output "extra_labels" {
  value = module.kube-prometheus.extra_labels
}

output "thanos_install" {
  value = module.kube-prometheus.thanos_install
}

output "thanos_object_store_secret_name" {
  value = module.kube-prometheus.thanos_object_store_secret_name
}

output "k8s_secret_infra_basic_auth_password" {
  sensitive = false
  value     = module.kube-prometheus.k8s_secret_infra_basic_auth_password
}

# thanos module
output "thanos_domain_name" {
  value = module.thanos.thanos_domain_name
}

output "thanos_bucket" {
  value = module.thanos.thanos_bucket
}

output "thanos_bucket_user" {
  value = module.thanos.thanos_bucket_user
}