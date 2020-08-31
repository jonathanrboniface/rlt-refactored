module "gke" {
  source = "./modules/gke"
  # providers = {
  #   kubernetes.src = kubernetes.kube
  # }
  project = "${var.project}"
  region  = "${var.region}"
}

module "cloudbuild" {
  source = "./modules/cloudbuild"
}
module "container_registry" {
  source = "./modules/container_registry"
}

# module "ha_vpn_gateway" {
#   source = "./modules/ha_vpn_gateway"
# }


# module "lb-deployment-service" {
#   source                 = "./modules/lb-deployment-service"
#   host                   = "http://${module.gke.host}"
#   client_certificate     = module.gke.client_certificate
#   client_key             = module.gke.client_key
#   cluster_ca_certificate = module.gke.cluster_ca_certificate
# }

# module "ingress" {
#   source     = "./modules/ingress"
#   depends_on = [module.gke]
#   providers = {
#     kubernetes = kubernetes
#   }
# }
