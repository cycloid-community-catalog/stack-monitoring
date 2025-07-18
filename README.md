# Stack-monitoring

This stack provides a way to deploy a monitoring solution based on the default Prometheus stack by deploying [Prometheus](https://prometheus.io/docs/introduction/overview/), [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) and [Grafana](https://grafana.com/).

There's 2 possible ways to deploy the monitoring solution:

- using a VM with prometheus stack installed as services
- using the k8s prometheus stack.

You should choose the corresponding usecase for the provider that you require

## Features

This stack allows to install:

- **Prometheus**: Time-series database for monitoring and alerting

- **Grafana**: Dashboard and visualization tool for Prometheus metrics

- **Alertmanager**: Handles alerts sent by client applications

- **Metrics Exporters**: Set of metrics exporters compatible with Prometheus

