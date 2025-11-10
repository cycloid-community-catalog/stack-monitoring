terraform {
  required_version = ">= 1.0"

  required_providers {
    # Use to merge complex map
    deepmerge = {
      source  = "isometry/deepmerge"
      version = "~> 1.0"
    }
  }
}
