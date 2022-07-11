// This is the service account for the cloud run service
resource "google_service_account" "cr-sa" {
  account_id   = var.service_account_name
  display_name = var.service_account_name
}
// It needs to be a service account user, have developer privs (to push revisions)
// and it needs to be able to write to the GCR bucket
resource "google_project_iam_member" "cr-sa-binding" {
  project = data.google_project.project.id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cr-sa.email}"
}
resource "google_project_iam_member" "cr-sa-service-agent" {
  project = data.google_project.project.id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.cr-sa.email}"
}
data "google_storage_bucket" "container-bucket" {
  name = var.container_bucket_name
}
resource "google_storage_bucket_iam_binding" "bucket-writer" {
  bucket = data.google_storage_bucket.container-bucket.name
  role   = "roles/storage.legacyBucketWriter"
  members = [
    "serviceAccount:${google_service_account.cr-sa.email}"
  ]
}
resource "google_service_account_iam_binding" "sa_user" {
  service_account_id = google_service_account.cr-sa.id
  role               = "roles/iam.serviceAccountUser"
  members = [
    "serviceAccount:${google_service_account.cr-sa.email}"
  ]
}
// setup identity pool and auth from the repo
resource "google_iam_workload_identity_pool" "id-pool" {
  project                   = data.google_project.project.project_id
  provider                  = google-beta
  workload_identity_pool_id = var.identity_pool_name
}
resource "google_iam_workload_identity_pool_provider" "github" {
  provider                           = google-beta
  project                            = data.google_project.project.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.id-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  attribute_mapping = {
    "google.subject"       = "assertion.sub",
    "attribute.actor"      = "assertion.actor",
    "attribute.aud"        = "assertion.aud",
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}
resource "google_service_account_iam_binding" "publisher" {
  service_account_id = google_service_account.cr-sa.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.id-pool.workload_identity_pool_id}/attribute.repository/puppetlabs/${var.repository_name}"
  ]
}