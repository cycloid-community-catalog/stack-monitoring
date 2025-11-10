terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {}
    helm       = {}
    cycloid = {
      source = "registry.terraform.io/cycloidio/cycloid"
    }
    grafana = {
      source = "registry.terraform.io/grafana/grafana"
    }
  }
}
