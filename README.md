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

## Usecase documention

To get more documentation for each of these usecases please go to the readme corresponding sections:
- [vm usecase doc](docs/vm_usecase.md)
- [k8s usecase doc](docs/k8s_usecase.md)

## Official documentation

- [Prometheus Template examples](https://prometheus.io/docs/prometheus/latest/configuration/template_examples/)
- [Prometheus Alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)
- [Alertmanager Configuration](https://prometheus.io/docs/alerting/latest/configuration/)

## Other interesting docs

- If you need ideas/inspiration of alerts to put in place for alerting:
	- https://monitoring.mixins.dev/
	-https://samber.github.io/awesome-prometheus-alerts/
