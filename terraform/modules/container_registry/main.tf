resource "google_container_registry" "registry" {
}
resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_container_registry.registry.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.service_account}"
}
data "google_container_registry_image" "default" {
  name = var.name
  tag  = "latest"
}
