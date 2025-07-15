module "cycloid-credentials" {
  #####################################
  # Do not modify the following lines #
  source       = "./cycloid-credentials"
  project      = var.project
  env          = var.env
  organization = var.organization
  #####################################

  enable_ssh         = module.aws-vm.enable_ssh
  vm_private_ssh_key  = module.aws-vm.ssh_private_key

  prometheus_install = module.aws-vm.prometheus_install
  prometheus_username = module.aws-vm.prometheus_basic_auth_username
  prometheus_password = module.aws-vm.prometheus_basic_auth_password

  alertmanager_install  = module.aws-vm.alertmanager_install
  alertmanager_username = module.aws-vm.alertmanager_basic_auth_username
  alertmanager_password = module.aws-vm.alertmanager_basic_auth_password

  grafana_install  = module.aws-vm.grafana_install
  grafana_username = module.aws-vm.grafana_basic_auth_username
  grafana_password = module.aws-vm.grafana_basic_auth_password

  depends_on = [module.aws-vm]
}