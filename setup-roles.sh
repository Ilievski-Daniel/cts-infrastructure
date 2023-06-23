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

success=true

for role in "${roles[@]}"
do
  gcloud projects add-iam-policy-binding "$project_id" --member="serviceAccount:$service_account_email" --role="$role" || success=false
done

gsutil iam ch "serviceAccount:$service_account_email:roles/storage.objectAdmin" "gs://$bucket_name" || success=false

if [ "$success" = true ]; then
  echo "Script executed successfully!"
else
  echo "Script execution encountered errors."
fi

gcloud projects get-iam-policy "$project_id" --flatten="bindings[].members" --format='table(bindings.role)' --filter="bindings.members:$service_account_email"
