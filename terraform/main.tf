provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
data "google_project" "project" {
  project_id = var.gcp_project
}
# ==========
# VARIABLES
# ==========
variable "container_name" {
  type    = string
  default = "your_container_name"
}
variable "gcp_project" {
  type    = string
  default = "your-project-name"
}
variable "gcp_region" {
  type    = string
  default = "us-central1"
}
variable "container_bucket_name" {
  type    = string
  default = "artifacts.your-project-name.appspot.com"
}
variable "service_account_name" {
  type    = string
  default = "cloud-run-service-account"
}
variable "identity_pool_name" {
  type    = string
  default = "cloud-run-id-pool"
}
variable "repository_name" {
  type    = string
  default = "some-repo-name"
}
variable "cr_service_name" {
  type    = string
  default = "cloud-run-svc"
}
# ==========
# OUTPUTS
# ==========
output "cloud_run_url" {
  value       = google_cloud_run_service.cloud_run_svc.status[0].url
  description = "The trigger url for the cloud run service"
}
output "service_account_email" {
  value       = google_service_account.cr-sa.email
  description = "The email address for the identity pool service account"
}