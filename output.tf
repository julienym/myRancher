output "rancher_token" {
  value = nonsensitive(rancher2_bootstrap.admin.token)
}