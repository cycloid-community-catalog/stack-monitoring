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
  url = var.cycloid_api_url
  # The Cycloid API key to use.
  jwt = var.cycloid_api_key

  organization_canonical = "cycloid-io"
}