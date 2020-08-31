locals {
  sites = {
    "cheddar" = {
      name        = "cheddar"
      port        = 80
      target_port = 80
    },
    "echoserver" = {
      name        = "echoserver"
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_service" "cheddar" {
  for_each = local.sites
  metadata {
    name = each.value.name
  }

  spec {
    selector = {
      app = each.value.name
    }

    port {
      port        = each.value.port
      target_port = each.value.target_port
    }

    type = "NodePort"
  }
  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.primary,
    kubernetes_namespace.staging,
    kubernetes_ingress.example
  ]
}
