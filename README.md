* update `main.tf`:
    * set `container_name`
    * set `gcp_project` with the appropriate name (e.g. `some-project-23498`)
    * update `gcp_region` to the appropriate region
    * update  `container_bucket_name` to the name of the bucket storing your container images
        * e.g. `artifacts.some-project-23498.appspot.com`
    * update `service_account_name` to a more descriptive service account name
    * update `github_org_name` to the name of your github org, or github username
    * update `identity_pool_name` to a more descriptive name
    * update `repository_name` to the name of your github repository
    * update `cr_service_name` to the name you want for your cloud run service

* if you're using GCP secrets, look at the sample secrets in `terraform/cloud_run.tf:20` and `terraform/secrets.tf` and modify for your needs

* modify your IAM policy in `terraform/cloud_run.tf:42` if this cloud run service shouldn't be open to all users

* update the Makefile:
    * set `GCP_PROJECT` to the same value as `gcp_project` in `main.tf`
    * set `CONTAINER_NAME` to the same value as `container_name` in `main.tf`

* deploy the terraform. It will output:
    * `cloud_run_url`: the URL for your cloud run instance
    * `service_account_email`: the e-mail address for the service account for the identity pool

* update `deploy.yaml`
    * replace `<your GCP project #>` with your GCP project number. (e.g. 123456789012)
    * replace `<your pool name>` to the value you set in `identity_pool_name` in `main.tf`
    * replace `<service_account_email>` with the output from the terraform deploy
    * replace `<cr_service_name>` with the same value you set in `main.tf`
    * replace `<container_name>` with the value you set in `container_name` in `main.tf`
    * (optional) - use a tag other than `latest` in line 37 of `deploy.yaml`
