# Stack-monitoring

This stack provides a way to deploy a monitoring server based on either a specific cloud provider solution or Prometheus.

There's 3 possible ways to deploy the monitoring solution:

- using a VM with docker (AWS and Azure)
- using the k8s prometheus stack (k8s only).

You should choose the corresponding usecase for the provider that you require

## Features

This stack allows to install:

- **Prometheus**: Time-series database for monitoring and alerting

- **Grafana**: Dashboard and visualization tool for Prometheus metrics

- **Alertmanager**: Handles alerts sent by client applications

- **Metrics Exporters**: Set of metrics exporters compatible with Prometheus


## Requirements

- Debian 12 (default OS to be used in the machines)

- Kubernetes cluster version >= 1.19

# How does it work

TODO


## Scraping

TODO

## Example configuration

TODO
