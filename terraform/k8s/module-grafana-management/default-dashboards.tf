################################################################################
# Create the different grafana dashboards in the corresponding folders
# As defined by the structure inside the grafana-dashboards forlders
# Always imports the default ones (cycloid product)
# + creates empty dashbord test folders
# + all json files created directly at base directory are created in test dir
################################################################################

resource "grafana_folder" "dashboard-test" {
  title = "Dashboard Tests"
  uid   = "dashboard-tests"
}

# Create Grafana folders based on the directory structure, escpect basis directory
resource "grafana_folder" "folders" {
  for_each = toset([for file, dir in local.dashboard_paths : dir if dir != "."])

  title = each.key
  uid   = each.key
}

# Create Grafana dashboards in the respective folders
resource "grafana_dashboard" "dashboards" {
  for_each = local.dashboard_files

  config_json = file("${path.module}/../grafana-dashboards/${each.key}")
  overwrite   = true
  # Conditionally set the folder attribute based on the directory structure
  folder = local.dashboard_paths[each.key] != "." ? grafana_folder.folders[local.dashboard_paths[each.key]].id : ""
}