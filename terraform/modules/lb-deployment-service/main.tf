provider "kubernetes" {
  version                = "~> 1.10.0"
  host                   = "http://${var.host}"
  token                  = data.google_client_config.current.access_token
  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
data "google_client_config" "current" {
}

resource "kubernetes_deployment" "rlt-test" {
  metadata {
    name = var.name
    labels = {
      App = var.name
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = var.name
      }
    }
    template {
      metadata {
        labels = {
          App = var.name
        }
      }
      spec {
        container {
          #  image = "nginx:1.7.8"
          image = "gcr.io/${var.project}/${var.name}:latest"
          name  = var.name

          port {
            container_port = 80
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "rlt-test" {
  metadata {
    name = var.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.rlt-test.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
  depends_on = [
    kubernetes_deployment.rlt-test
  ]

}
