################################################################################
# Create the different grafana dashboards in the corresponding folders
# As defined by the structure inside the grafana-dashboards forlders
# Always imports the default ones (cycloid product)
# + creates empty dashbord test folders
################################################################################

resource "grafana_folder" "dashboard-test" {
  title = "Dashboard Test"
}

# Create Grafana folders based on the directory structure
resource "grafana_folder" "folders" {
  for_each = toset([for file, dir in local.dashboard_paths : dir])

  title = each.key
}

# Create Grafana dashboards in the respective folders
resource "grafana_dashboard" "dashboards" {
  for_each = local.dashboard_files

  config_json = file("${path.module}/../grafana-dashboards/${each.key}")
  folder      = grafana_folder.folders[local.dashboard_paths[each.key]].id
}