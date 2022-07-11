// This will deploy whatever latest is the first time
// but then never pull it again. Updates to the container
// MUST be handled elsewhere and NOT by running terraform
// see the makefile for updating the container and cloud run
data "google_container_registry_image" "cloud-run-svc-image" {
  name    = var.container_name
  project = var.gcp_project
  tag     = "latest"
}
// this is the actual cloud service
resource "google_cloud_run_service" "cloud_run_svc" {
  name     = var.cr_service_name
  location = var.gcp_region
  project  = var.gcp_project

  template {
    spec {
      containers {
        image = data.google_container_registry_image.cloud-run-svc-image.image_url
        # env {
        #   name = "GITHUB_TOKEN"
        #   value_from {
        #     secret_key_ref {
        #       name = data.google_secret_manager_secret.github_token.secret_id
        #       key  = "latest"
        #     }
        #   }
        # }
      }
      service_account_name = google_service_account.cr-sa.email
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "1"
      }
    }
  }
  autogenerate_revision_name = true
  depends_on = [google_service_account.cr-sa]
}

data "google_iam_policy" "no_auth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "no_auth" {
  location = google_cloud_run_service.cloud_run_svc.location
  project  = google_cloud_run_service.cloud_run_svc.project
  service  = google_cloud_run_service.cloud_run_svc.name

  policy_data = data.google_iam_policy.no_auth.policy_data
}
