provider "kubernetes" {
  config_context = var.kubeconfig_content
}

provider "helm" {
  kubernetes {
    config_context = var.kubeconfig_content
  }
}
