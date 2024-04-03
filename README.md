# stack-monitoring

This stack provides a way to deploy a monitoring server based on either a specific cloud provider solution or Prometheus.

There's 3 possible ways to deploy the monitoring solution:

- using a VM with docker
- using a cloud provider managed solution if available
- using the k8s prometheus stack (k8s only)

You should choose the corresponding usecase for the provider that you require
