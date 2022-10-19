module "netdata" {
  count = var.netdata.enabled ? 1 : 0
  # source = "git::https://github.com/julienym/myTerraformModules.git//helm?ref=1.0.0"
  source = "../myTerraformModules/helm"

  name = "netdata"
  repository = "https://netdata.github.io/helmchart/"
  namespace = "netdata"
  chart = "netdata"
  chart_version = "3.7.22"
  # https://github.com/netdata/helmchart/blob/master/charts/netdata/values.yaml
  values_file = "${path.module}/charts/netdata/default.yaml"
  
  secret_values = {
    "parent.claiming.token" = var.netdata.token
    "child.claiming.token" = var.netdata.token
  }
}
