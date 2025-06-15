resource "kubernetes_namespace_v1" "name" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace_v1.name.id
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = "25.18.0" # optional

  set {
    name  = "prometheus.grafana.enabled"
    value = "false"
  }
}

resource "helm_release" "loki_stack" {
  name       = "grafana"
  namespace  = kubernetes_namespace_v1.name.id
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  create_namespace = true

  set {
    name  = "grafana.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = "false"
  }

  set {
    name  = "loki.enabled"
    value = "true"
  }

  set {
    name  = "fluent-bit.enabled"
    value = "true"
  }

  set {
    name  = "promtail.enabled"
    value = "false"
  }

  set {
    name  = "adminPassword"
    value = "admin"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}


resource "helm_release" "fluent_bit" {
  name             = "fluent-bit"
  namespace        = kubernetes_namespace_v1.name.id
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluent-bit"
  create_namespace = true

  set {
    name  = "backend.type"
    value = "loki"
  }

  set {
    name  = "backend.loki.host"
    value = "grafana-loki.monitoring.svc.cluster.local"
  }

  set {
    name  = "backend.loki.port"
    value = "3100"
  }

  set {
    name  = "backend.loki.uri"
    value = "/loki/api/v1/push"
  }

  set {
    name  = "backend.loki.tls"
    value = "off"
  }

  set {
    name  = "serviceMonitor.enabled"
    value = "true"
  }
}
