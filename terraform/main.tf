resource "google_storage_bucket" "demo-storage-puplampu-2024" {
  encryption {
    default_kms_key_name = "projects/puplampu-inc-project01/locations/us-central1/keyRings/demo-storage-puplampu-2024/cryptoKeys/demo-storage-puplampu-2024"
  }

  force_destroy               = false
  location                    = "US-CENTRAL1"
  name                        = "demo-storage-puplampu-2024"
  project                     = "puplampu-inc-project01"
  public_access_prevention    = "inherited"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
# terraform import google_storage_bucket.demo-storage_puplampu_2024 demo-storage-puplampu-2024


resource "google_compute_disk" "lamp_3_vm" {
  image                     = "https://www.googleapis.com/compute/beta/projects/click-to-deploy-images/global/images/lamp-v20240121"
  name                      = "lamp-3-vm"
  physical_block_size_bytes = 4096
  project                   = "puplampu-inc-project01"
  size                      = 20
  type                      = "pd-standard"
  zone                      = "us-central1-a"
}
# terraform import google_compute_disk.lamp_4_vm projects/puplampu-inc-project01/zones/us-central1-a/disks/lamp-3-vm
