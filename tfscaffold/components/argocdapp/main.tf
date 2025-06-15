
resource "kubernetes_manifest" "sample_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name       = "spring-boot-react-k8s-manifest"
      namespace  = data.terraform_remote_state.argocd.outputs.argocd_namespace
      finalizers = ["resources-finalizer.argocd.argoproj.io"]
    }

    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/xmgeorge/spring-boot-react-k8s-manifest.git"
        targetRevision = "main"
        path           = "overlays/dev/"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune      = true
          selfHeal   = true
          allowEmpty = false
        }
      }
    }
  }
}
