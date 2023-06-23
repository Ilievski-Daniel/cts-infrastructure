#!/bin/bash

project_id="$1"
service_account_email="$2"
bucket_name="$3"

roles=(
  "roles/compute.admin"
  "roles/iam.serviceAccountUser"
  "roles/resourcemanager.projectIamAdmin"
  "roles/container.clusterAdmin"
  "roles/compute.securityAdmin"
  "roles/iam.serviceAccountAdmin"
)

for role in "${roles[@]}"
do
  gcloud projects add-iam-policy-binding "$project_id" --member="serviceAccount:$service_account_email" --role="$role"
done

gsutil iam ch "serviceAccount:$service_account_email:roles/storage.objectAdmin" "gs://$bucket_name"
