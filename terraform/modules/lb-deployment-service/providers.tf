provider "google" {
  project = var.project
  region  = var.region
}

provider "google-beta" {
  project = var.project
  region  = var.region
}


# provider "kubernetes" {
#   alias   = "kube"
#   version = "~> 1.10.0"
#   host    = "http://${module.gke.vpc_native_cluster.endpoint}"
#   token   = data.google_client_config.current.access_token
#   client_certificate = base64decode(
#     module.gke.google_container_cluster.primary.master_auth[0].client_certificate,
#   )
#   client_key = base64decode(module.gke.google_container_cluster.primary.master_auth[0].client_key)
#   cluster_ca_certificate = base64decode(
#     module.gke.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
#   )
# }
