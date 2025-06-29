terraform {
  required_version = ">= 1.0"

  required_providers {

    kubernetes = {
      version = ">= 2.22.0"
    }

    helm = {
      version = "= 2.17.0"
    }
    cycloid = {
      source = "registry.terraform.io/cycloidio/cycloid"
    }
    grafana = {
      source = "registry.terraform.io/grafana/grafana"
    }
  }
}