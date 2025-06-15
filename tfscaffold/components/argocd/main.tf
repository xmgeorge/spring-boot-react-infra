resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "8.0.17"
  namespace        = kubernetes_namespace_v1.argocd.id
  create_namespace = false

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "server.service.port"
    value = "80"
  }

  set {
    name  = "configs.params.server.insecure"
    value = "false"
  }

  set {
    name  = "configs.params.server.insecure"
    value = "true"
  }

  # Readiness probe config
  set {
    name  = "server.readinessProbe.httpGet.path"
    value = "/healthz"
  }

  set {
    name  = "server.readinessProbe.httpGet.port"
    value = "8080"
  }

  set {
    name  = "server.readinessProbe.initialDelaySeconds"
    value = "10"
  }

  set {
    name  = "server.readinessProbe.periodSeconds"
    value = "10"
  }

  # Liveness probe config
  set {
    name  = "server.livenessProbe.httpGet.path"
    value = "/healthz"
  }

  set {
    name  = "server.livenessProbe.httpGet.port"
    value = "8080"
  }

  set {
    name  = "server.livenessProbe.initialDelaySeconds"
    value = "15"
  }

  set {
    name  = "server.livenessProbe.periodSeconds"
    value = "20"
  }

  set {
    name  = "server.extraEnv[0].name"
    value = "ARGOCD_SERVER_HTTP_PORT"
  }

  set {
    name  = "server.extraEnv[0].value"
    value = "8080"
  }

  set {
    name  = "server.extraEnv[1].name"
    value = "PROXY_PROTO_HEADER"
  }

  set {
    name  = "server.extraEnv[1].value"
    value = "X-Forwarded-Proto"
  }
}

