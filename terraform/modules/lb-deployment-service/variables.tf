variable "project" {
  type    = string
  default = "elasticsearch-236916"
}
variable "name" {
  type    = string
  default = "rlt-test"
}
variable "region" {
  type    = string
  default = "us-central1"
}
variable client_certificate {}
variable client_key {}
variable cluster_ca_certificate {}
variable host {}
