resource "google_cloudbuild_trigger" "rlt-test" {
  trigger_template {
    branch_name = "master"
    repo_name   = var.name
  }
  project = var.project

  filename = "./cloudbuild.yaml"
}
