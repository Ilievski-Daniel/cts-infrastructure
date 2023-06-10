terraform {
  backend "gcs" {
    bucket      = "cts-terraform-backend-bucket"
    prefix      = "terraform/state"
    credentials = "./cred.json"
  }
}
