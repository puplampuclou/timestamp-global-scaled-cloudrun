resource "google_kms_key_ring" "key_ring" {
  name     = "demo-key-timestamp-2024"
  location = "us-central"  # Replace with your desired location
}

resource "google_kms_crypto_key" "crypto_key" {
  name            = "demo-timestamp-rp-2024"
  key_ring        = google_kms_key_ring.key_ring.id
  purpose         = "ENCRYPT_DECRYPT"
}

# Grant necessary permissions to the Key, using the retrieved bucket's service account
#resource "google_kms_crypto_key_iam_binding" "storage_bucket_access" {
#  crypto_key_id = google_kms_crypto_key.crypto_key.id
#  role          = "roles/storage.objectCreator"
#  members       = ["serviceAccount:${data.google_storage_bucket.demo_bucket.iam_service_account.selfLink}"]
#}

# Storage bucket resource with default KMS encryption
resource "google_storage_bucket" "demo_bucket" {
  name     = "demo-timestamp-rp-2024"  # Ensure this matches the data resource name
  location = "us-central"  # Replace with your desired location

  encryption {
    default_kms_key_name = google_kms_crypto_key.crypto_key.name
  }
}

output "default_kms_key_name" {
  value = google_kms_crypto_key.crypto_key.name
}

# Data resource to retrieve information about the existing bucket
#data "google_storage_bucket" "demo_bucket" {
#  name = "demo-timestamp-rp-2024"  # Replace with the actual bucket name
#}

resource "google_compute_disk" "lamp_4_vm" {
  image                     = "https://www.googleapis.com/compute/beta/projects/click-to-deploy-images/global/images/lamp-v20240121"
  name                      = "lamp-4-vm"
  physical_block_size_bytes = 4096
  project                   = "puplampu-inc-project01"
  size                      = 20
  type                      = "pd-standard"
  zone                      = "us-central1-a"
}
# terraform import google_compute_disk.lamp_4_vm projects/puplampu-inc-project01/zones/europe-west4-a/disks/lamp-4-vm
