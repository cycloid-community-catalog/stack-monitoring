terraform {
  required_version = ">= 1.0"

  required_providers {
    #aws = { todo change after tests in minikube
    #  source  = "hashicorp/aws"
    #  version = ">= 5.11.0"
    #}

    kubernetes = {
      version = ">= 2.22.0"
    }

    helm = {
      version = ">= 2.6.0"
    }
  }
}