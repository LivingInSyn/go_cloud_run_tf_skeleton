## This is sample Terraform secrets code. The secrets should be
## Created and imported manually or somewhere else, not in this terraform

# // import our secrets
# data "google_secret_manager_secret" "github_token" {
#   project   = var.gcp_project
#   secret_id = "github-token"
# }
# // import our secrets versions
# data "google_secret_manager_secret_version" "github_token" {
#   project = var.gcp_project
#   secret  = data.google_secret_manager_secret.github_token.id
# }
# // setup the permissions on those secrets though in TF:
# resource "google_secret_manager_secret_iam_binding" "secret-access-cloud-run-github" {
#   secret_id  = data.google_secret_manager_secret.github_token.id
#   role       = "roles/secretmanager.secretAccessor"
#   members    = ["serviceAccount:${google_service_account.cr-sa.email}"]
#   depends_on = [google_service_account.cr-sa, data.google_secret_manager_secret.github_token]
# }
