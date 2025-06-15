output "argocd_metadata" {
  value = helm_release.argo_cd.metadata
}

# output "argocd_initial_admin_secret" {
#   description = "Command to get the Argo CD initial admin password"
#   value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d"
# }

output "argocd_namespace" {
  value = helm_release.argo_cd.namespace
}