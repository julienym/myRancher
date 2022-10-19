resource "kubectl_manifest" "rancher_ns" {
    yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata:
  name: cattle-system
YAML
}

resource "kubectl_manifest" "rancher_cert" {
  count = var.cert-manager.enabled ? 1 : 0
  depends_on = [
    module.cert-manager,
    kubectl_manifest.rancher_ns
  ]

  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: rancher-tls
  namespace: cattle-system
spec:
  secretName: tls-rancher-ingress
  dnsNames:
    - ${var.rancher.domain}
  issuerRef:
    name: cloudflare-issuer
    kind: ClusterIssuer
    group: cert-manager.io
YAML
}

module "rancher" {
  depends_on = [
    module.cert-manager[0],
    kubectl_manifest.rancher_cert[0],
  ]
  # source = "git::https://github.com/julienym/myTerraformModules.git//helm?ref=1.0.0"
  source = "../myTerraformModules/helm"
  
  name = "rancher"
  repository = "https://releases.rancher.com/server-charts/stable"
  namespace = "cattle-system"
  chart = "rancher"
  chart_version = var.rancher.version
  values = {
    hostname = var.rancher.domain
    "ingress.tls.source" =  var.cert-manager.enabled ? "secret" : "rancher"
    bootstrapPassword = var.rancher_bootstrap
    "certmanager.version" = var.cert-manager.enabled ? "1.7.1" : null
    replicas = var.rancher.replicas
  }
}

resource "rancher2_bootstrap" "admin" {
  depends_on = [
    module.rancher
  ]
  provider = rancher2.bootstrap

  initial_password = var.rancher_bootstrap
  password = var.rancher_bootstrap
  telemetry = true
}