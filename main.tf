terraform {
  required_providers {
    google = { source = "hashicorp/google", version = "~> 5.30" }
    google-beta = { source = "hashicorp/google-beta", version = "~> 5.30" }
  }
}

provider "google" {
  project = var.project
  region  = "us-central1"
}

provider "google-beta" {
  project = var.project
  region  = "us-central1"
}

resource "google_artifact_registry_repository" "labs" {
  location      = "us-central1"
  repository_id = "labs"
  format        = "DOCKER"
}

resource "google_cloudbuild_trigger" "main" {
  provider = google-beta
  name     = "ship-it-on-push"
  location = "us-central1"

  service_account = "projects/week14-lab/serviceAccounts/206854912688-compute@developer.gserviceaccount.com"

  repository_event_config {
    repository = "projects/week14-lab/locations/us-central1/connections/github-conn/repositories/josh-edralin-lab-w14"
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"
}

resource "google_cloud_run_v2_service" "app" {
  name     = "ship-it"
  location = "us-central1"
  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
    }
  }
  lifecycle { ignore_changes = [template[0].containers[0].image] }
}