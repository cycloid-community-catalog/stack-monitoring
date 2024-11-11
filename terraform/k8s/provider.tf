provider "kubernetes" {
  config_path = var.kubeconfig_filename
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_filename
  }
}
