resource "kubernetes_ingress" "example" {
  metadata {
    name = "example"

    annotations = {
      "ingress.kubernetes.io/rewrite-target" = "/"
    }
  }

  spec {
    backend {
      service_name = "cheddar"
      service_port = 80
    }

    rule {
      host = "reachbeyond.me"

      http {
        path {
          path = "/"

          backend {
            service_name = "echoserver"
            service_port = 80
          }
        }

        path {
          path = "/cheddar"

          backend {
            service_name = "cheddar"
            service_port = 80
          }
        }
      }
    }
  }
}



