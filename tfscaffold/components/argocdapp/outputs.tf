
output "AccessAgroCDGUI" {
  description = "Access argocd GUI from local desktop"
  value       = "kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443"
}

output "ArgocdPassword" {
  description = "Get argocd password"
  value       = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
}

