module "cert-manager" {
  count = var.cert-manager.enabled ? 1 : 0
  # source = "git::https://github.com/julienym/myTerraformModules.git//helm?ref=1.0.0"
  source = "../myTerraformModules/helm"

  name = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace = "cert-manager"
  chart = "cert-manager"
  chart_version = "v1.7.1"
  # https://github.com/cert-manager/cert-manager/blob/master/deploy/charts/cert-manager/values.yaml
  values_file = "${path.module}/charts/cert-manager/default.yaml"
}

resource "kubectl_manifest" "cloudflare_secret" {
  count = var.cert-manager.enabled ? 1 : 0
  depends_on = [
    module.cert-manager
  ]

    yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: cloudflare-api-token-secret
  namespace: cert-manager
type: Opaque
data:
  api-token: ${base64encode(var.cloudflare.api_token)}
YAML
}

resource "kubectl_manifest" "cloudflare_cluster_issuer" {
  count = var.cert-manager.enabled ? 1 : 0
  depends_on = [
    module.cert-manager,
    kubectl_manifest.cloudflare_secret
  ]
  
    yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: cloudflare-issuer
spec:
  acme:
    email: ${var.acme_email}
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: cloudflare-issuer-account-key
    solvers:
    - dns01:
        cloudflare:
          apiTokenSecretRef:
            name: cloudflare-api-token-secret
            key: api-token
YAML
}