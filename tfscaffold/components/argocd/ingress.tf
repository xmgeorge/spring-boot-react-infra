resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "argocd-ingress"
    namespace = "argocd"
    annotations = {
      "nginx.ingress.kubernetes.io/affinity"            = "cookie"
      "nginx.ingress.kubernetes.io/backend-protocol"    = "HTTP"
      "nginx.ingress.kubernetes.io/session-cookie-name" = "argocd-session"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"  = "false"
    }
  }


  spec {

    ingress_class_name = "nginx"

    rule {
      host = "argocd.georgeulahannan.live"
      http {

        path {
          backend {
            service {
              name = "argocd-server"
              port {
                number = 80
              }
            }
          }

          path      = "/"
          path_type = "Prefix"
        }

      }
    }

  }
}