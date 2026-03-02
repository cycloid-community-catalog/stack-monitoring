provider "kubernetes" {
  config_path = var.kubeconfig_filename
}

provider "helm" {
  kubernetes = {
    config_path = var.kubeconfig_filename
  }
}

provider "cycloid" {
  # The Cycloid API URL to use.
  api_url = var.cycloid_api_url
  # The Cycloid API key to use.
  api_key = var.cycloid_api_key

  default_organization = var.organization
}

# provider declared here since the variables are defined in another module
provider "grafana" {
  url  = "https://${module.kube-prometheus.grafana_domain_name}"
  auth = "${module.kube-prometheus.grafana_basic_auth_username}:${module.kube-prometheus.grafana_basic_auth_password}"
}
