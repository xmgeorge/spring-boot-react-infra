resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argo_cd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "8.1.1"
  namespace        = kubernetes_namespace_v1.argocd.id
  create_namespace = false

  set {
    name  = "configs.cm.params.create"
    value = "true"
  }

  set {
    name  = "configs.cm.params.server.insecure"
    value = "true"
  }


  # set {
  #   name  = "metrics.enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "server.metrics.enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "controller.metrics.enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "repoServer.metrics.enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "applicationSet.metrics.enabled"
  #   value = "true"
  # }

  #  set {
  #   name  = "redis.metrics.enable"
  #   value = "true"
  # }

}