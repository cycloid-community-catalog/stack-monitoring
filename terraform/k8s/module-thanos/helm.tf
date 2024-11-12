################################################################################
# Helm-release: thanos
# CHART: https://github.com/bitnami/charts/tree/main/bitnami/thanos
# VALUES: https://github.com/bitnami/charts/blob/main/bitnami/thanos/values.yaml
# todo:  check limits, add oauth2, check storage if default increase 8-10Gi, compactor 20Gi, probes to keep?
################################################################################

# non string or boolean values cannot be set as value in helm
# https://github.com/hashicorp/terraform-provider-helm/issues/669
# all the map variables need to apply this little trick

locals {
  query_node_selector= <<EOL
---
query:
  nodeSelector:|
    ${indent(4, yamlencode(var.stack_monitoring_node_selector))}
EOL

  query_frontend_node_selector= <<EOL
---
queryFrontend:
  nodeSelector:|
    ${indent(4, yamlencode(var.stack_monitoring_node_selector))}
EOL

  compactor_node_selector= <<EOL
---
compactor:
  nodeSelector:|
    ${indent(4, yamlencode(var.stack_monitoring_node_selector))}
EOL

  storegateway_node_selector= <<EOL
---
storegateway:
  nodeSelector:|
    ${indent(4, yamlencode(var.stack_monitoring_node_selector))}
EOL
}

resource "helm_release" "thanos" {

  count = var.thanos_install ? 1 : 0

  name       = "thanos"
  repository = "https://github.com/bitnami/charts/tree/main/bitnami"
  chart      = "thanos"
  version    = var.thanos_helm_version
  namespace  = var.namespace

  values = [
    file("${path.module}/values.yaml"),
    local.query_node_selector,
    local.query_frontend_node_selector,
    local.compactor_node_selector,
    local.storegateway_node_selector
  ]
  # GENERAL VARS
  set {
    name  = "commonLabels"
    value = jsonencode(local.common_labels)
  }

  set {
    name  = "https.enabled"
    value = var.enable_tls
  }

  set {
    name  = "https.existingSecret"
    value = var.thanos_domain_name
  }

  set {
    name  = "auth.basicAuthUsers"
    value = "${var.thanos_basic_auth_username}:${var.thanos_basic_auth_password}"
  }

  set {
    name  = "existingObjstoreSecret"
    value = var.thanos_object_store_secret_name
  }
  # Query - connects to sidecar created by kube-prometheus-stack
  set {
    name  = "query.dnsDiscovery.sidecarsService"
    value = "prometheus-operated"
  }

  set {
    name  = "query.dnsDiscovery.sidecarsNamespace"
    value = var.namespace
  }

  #set {
  #  name  = "query.nodeSelector"
  #  value = var.stack_monitoring_node_selector
  #}

  # QueryFrontend - allows to create a service similiar to prometheus to read the data stored
  set {
    name  = "queryFrontend.ingress.enabled"
    value = true
  }

  set {
    name  = "queryFrontend.ingress.hostname"
    value = var.thanos_domain_name
  }

  set {
    name  = "queryFrontend.ingress.tls"
    value = var.enable_tls
  }

  #set {
  #  name  = "queryFrontend.nodeSelector"
  #  value = var.stack_monitoring_node_selector
  #}

  # Bucket web
  set {
    name  = "bucketweb.enabled"
    value = true
  }

  set {
    name  = "bucketweb.nodeSelector"
    value = jsonencode(var.stack_monitoring_node_selector)
  }

  # Compactor - compacts the data to be stored in remote storage
  set {
    name  = "compactor.enabled"
    value = true
  }

  set {
    name  = "compactor.retentionResolutionRaw"
    value = var.thanos_retention_raw
  }

  set {
    name  = "compactor.retentionResolution5m"
    value = var.thanos_retention_5m
  }

  set {
    name  = "compactor.retentionResolution1h"
    value = var.thanos_retention_1h
  }

  #set {
  #  name  = "compactor.nodeSelector"
  #  value = var.stack_monitoring_node_selector
  #}

  # Store Gtw - exposes the content of the bucket
  set {
    name  = "storegateway.enabled"
    value = true
  }

  #set {
  #  name  = "storegateway.nodeSelector"
  #  value = var.stack_monitoring_node_selector
  #}
  # Metrics - here allows to scrape metrics from the different thanos pods
  set {
    name  = "metrics.enabled"
    value = true
  }

  set {
    name  = "metrics.serviceMonitor"
    value = true
  }

}