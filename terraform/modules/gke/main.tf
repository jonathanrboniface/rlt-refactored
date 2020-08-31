# provider "kubernetes" {
#   version = "~> 1.10.0"
#   host    = google_container_cluster.primary.endpoint
#   token   = data.google_client_config.current.access_token
#   client_certificate = base64decode(
#     google_container_cluster.primary.master_auth[0].client_certificate,
#   )
#   client_key = base64decode(google_container_cluster.primary.master_auth[0].client_key)
#   cluster_ca_certificate = base64decode(
#     google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
#   )
# }

data "google_client_config" "current" {
}

resource "random_id" "cluster" {
  byte_length = 2
}

resource "google_compute_address" "default" {
  name   = var.network_name
  region = var.region
}

resource "google_container_cluster" "primary" {
  provider                 = google-beta
  name                     = "${var.cluster_name}-${random_id.cluster.hex}"
  location                 = var.location
  project                  = var.project
  remove_default_node_pool = true
  initial_node_count       = 1

  node_config {
    service_account = var.service_account
  }
  network    = "default"
  subnetwork = "default"

  network_policy {
    enabled = true
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  lifecycle {
    create_before_destroy = true
    # prevent_destroy       = true
    ignore_changes        = [node_pool]
  }
  timeouts {
    update = "20m"
  }


  # addons_config {
  #   istio_config {
  #     disabled = false
  #     auth     = "AUTH_NONE"
  #   }
  # }

  depends_on = [google_compute_address.default]

}

resource "google_container_node_pool" "primary" {
  name       = "my-node-pool"
  location   = "us-central1"
  project    = var.project
  cluster    = google_container_cluster.primary.name
  node_count = 1
  #  


  node_config {
    service_account = var.service_account
    oauth_scopes = [
      /*
      TO DO - Research into each of the below to determine if it is required to conform to least privileged access
    */
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.project
    }

    # preemptible  = true
    machine_type = "n1-standard-1"
    disk_size_gb = 10
    tags         = ["gke-node", "${var.project}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  lifecycle {
    create_before_destroy = true
    # prevent_destroy = true
  }
  timeouts {
    update = "20m"
  }

  depends_on = [google_container_cluster.primary]
}

resource "null_resource" "get-demo-credentials" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name}-${random_id.cluster.hex} --region ${var.region} --project ${var.project}"
  }
  depends_on = [google_container_node_pool.primary]
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging-${random_id.cluster.hex}"
  }
  depends_on = [google_container_node_pool.primary]
}


