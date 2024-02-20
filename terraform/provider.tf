#Google Terraform main.tf provider code.
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.16.0"
    }
  }
}
provider "google" {
  # Configuration options
  project     = "puplampu-inc-project01"
  region      = "us-central1"
  zone		  = "us-central1-a"
}
