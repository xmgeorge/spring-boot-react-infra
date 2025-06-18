resource "kubernetes_namespace_v1" "nginx_controller" {
  metadata {
    name = "ingress-nginx"
  }
}


resource "helm_release" "nginx_controller" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.12.3"

  namespace = kubernetes_namespace_v1.nginx_controller.id

  set {
    name  = "controller.kind"
    value = "Deployment"
  }

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.service.nodePorts.http"
    value = "30080"
  }

  set {
    name  = "controller.service.nodePorts.https"
    value = "30443"
  }

  set {
    name  = "controller.healthCheckPath"
    value = "/healthz"
  }

  set {
    name  = "controller.extraArgs.enable-ssl-passthrough"
    value = "false"
  }

}


# helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
#   --namespace ingress-nginx \
#   --set controller.kind=DaemonSet \
#   --set controller.service.type=NodePort \
#   --set controller.service.nodePorts.http=30080 \
#   --set controller.service.nodePorts.https=30443 \
#   --set controller.healthCheckPath=/healthz \
#   --set controller.extraArgs.enable-ssl-passthrough="false"