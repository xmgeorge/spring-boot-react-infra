resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argo_cd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.8.22"
  namespace        = kubernetes_namespace_v1.argocd.id
  create_namespace = false

  set {
    name  = "global.image.tag"
    value = "v2.14.9"
  }

  set {
  name  = "server.insecure"
  value = "true"
}

set {
  name  = "configs.params.server.insecure"
  value = "true"
}


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


#  helm upgrade --install argocd argo/argo-cd \
#   --namespace argocd \
#   --create-namespace \
#   --version 7.8.22 \
#   --set global.image.tag=v2.14.9 \
#   --set server.insecure=true \
#   --set metrics.enabled=true \
#   --set server.metrics.enabled=true \
#   --set controller.metrics.enabled=true \
#   --set repoServer.metrics.enabled=true \
#   --set applicationSet.metrics.enabled=true \
#   --set redis.metrics.enabled=true \
#   --set repoServer.persistence.enabled=true \
#   --set repoServer.persistence.storageClassName=ebs-wffc \
#   --set repoServer.persistence.size=10Gi
