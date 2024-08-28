#
# Outputs
#

# kube-prometheus-stack module
output "prometheus_dns" {
  value = module.kube-prometheus.prometheus_dns
}

output "alertmanager_dns" {
  value = module.kube-prometheus.alertmanager_dns
}

output "grafana_dns" {
  value = module.kube-prometheus.grafana_dns
}


output "stack_monitoring_node_selector" {
  value = module.kube-prometheus.stack_monitoring_node_selector
}

output "extra_labels" {
  value = module.kube-prometheus.extra_labels
}

output "enable_thanos" {
  value = module.kube-prometheus.enable_thanos
}

output "thanos_object_store_secret_name" {
  value = module.kube-prometheus.thanos_object_store_secret_name
}

# thanos module
output "thanos_dns" {
  value = module.thanos.thanos_dns
}

output "thanos_bucket" {
  value = module.thanos.thanos_bucket
}

output "thanos_bucket_user" {
  value = module.thanos.thanos_bucket_user
}