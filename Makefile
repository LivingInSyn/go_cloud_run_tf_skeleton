GCP_PROJECT ?= your-project-name-23498 # Auth action step exports this environment variable
CONTAINER_NAME ?= container_name
TAG ?= latest

build:
	docker build -t gcr.io/$(GCP_PROJECT)/$(CONTAINER_NAME):$(TAG) .
publish:
	make build
	docker push gcr.io/$(GCP_PROJECT)/$(CONTAINER_NAME):$(TAG)