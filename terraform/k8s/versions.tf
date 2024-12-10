terraform {
  required_version = ">= 1.0"

  required_providers {

    kubernetes = {
      version = ">= 2.22.0"
    }

    helm = {
      version = ">= 2.6.0"
    }
    cycloid = {
      source = "registry.terraform.io/cycloidio/cycloid"
    }
  }
}