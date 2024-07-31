terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>5.0"
    }
  }
}

data "google_client_config" "current" {
}

data "google_project" "current" {
}

locals {
  webhookUrl                  = "/webhook"
  projectId                   = data.google_client_config.current.project
  projectNumber               = data.google_project.current.number
  region                      = data.google_client_config.current.region
  zone                        = data.google_client_config.current.zone
  runnerLabel                 = join(",", var.github_runner_labels)
  runnerLabelInstanceTemplate = length(var.github_runner_labels) == 0 ? "" : format("--no-default-labels --labels '%s'", local.runnerLabel)
}

resource "google_project_service" "compute_api" {
  service = "compute.googleapis.com"
}

resource "google_project_service" "cloud_run_api" {
  service = "run.googleapis.com"
}

resource "google_project_service" "artifactregistry_api" {
  service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "cloudtasks_api" {
  service = "cloudtasks.googleapis.com"
}

resource "google_project_service" "secretmanager_api" {
  service = "secretmanager.googleapis.com"
}
