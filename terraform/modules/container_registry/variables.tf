variable "project" {
  type    = string
  default = "elasticsearch-236916"
}
variable "name" {
  type    = string
  default = "rlt-test"
}
variable "service_account" {
  type        = string
  default     = "jonathan-boniface@elasticsearch-236916.iam.gserviceaccount.com"
  description = "service account"
}
variable "region" {
  type    = string
  default = "us-central1"
}
