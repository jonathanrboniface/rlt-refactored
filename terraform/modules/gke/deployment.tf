resource "kubernetes_deployment" "cheddar" {
  metadata {
    name = "cheddar-cheese"
  }

  spec {
    selector {
      match_labels = {
        app = "cheddar"
      }
    }

    template {
      metadata {
        labels = {
          app = "cheddar"
        }
      }

      spec {
        container {
          name  = "cheddar"
          image = "gcr.io/${var.project}/${var.name}:latest"


          port {
            container_port = 80
          }
        }
      }
    }
  }
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary,
    kubernetes_namespace.staging,
    kubernetes_ingress.example
    ]
}



resource "kubernetes_deployment" "echoserver" {
  metadata {
    name = "echoserver"
  }

  spec {
    selector {
      match_labels = {
        app = "echoserver"
      }
    }

    template {
      metadata {
        labels = {
          app = "echoserver"
        }
      }

      spec {
        container {
          name  = "echoserver"
          image = "gcr.io/${var.project}/${var.name}:latest"

          port {
            container_port = 80
          }
        }
      }
    }
  }
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary,
    kubernetes_namespace.staging,
    kubernetes_ingress.example
  ]
}
