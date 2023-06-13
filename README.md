# CTS Infrastructure

The CTS Infrastructure uses multiple modules in order to obtain it's functionality:

- GKE Cluster
- GKE Authentication
- GCP Network

There are 2 required providers that are being used:

- Google
- Kubernetes

And finnaly we use Google Cloud Storage (bucket) as a Terraform backend to securely store and manage our infrastructure state, providing durability, scalability, accessibility, collaboration, and automation.

## Prerequisites

- Terraform: Install Terraform on your local machine. You can download the latest version from the official Terraform website (https://www.terraform.io/downloads.html) and follow the installation instructions for your operating system.

- Google Cloud Account: Sign up for a Google Cloud account if you don't already have one. You can create an account at the Google Cloud Console (https://console.cloud.google.com/). Make sure you have the necessary permissions to create and manage resources in your Google Cloud project.

- Google Cloud CLI: Install the Google Cloud SDK (Software Development Kit) on your local machine. The SDK includes the command-line tools required to interact with Google Cloud services. You can download the SDK from the Google Cloud website (https://cloud.google.com/sdk/docs/install) and follow the installation instructions for your operating system.

- Authentication: Configure authentication for the Google Cloud CLI. You can authenticate by running the ```gcloud auth application-default login``` command to log in with your Google Cloud account credentials.

- Initialize Backend: Initialize the Terraform backend to specify the storage location for the Terraform state. In this case, use the gcs (Google Cloud Storage) backend and provide the bucket name where you want to store the state file.

## Steps to deploy the infrastructure:

1. Clone Repository: Clone the repository containing the Terraform configuration files to your local machine.

    ```sh
    git clone https://github.com/Ilievski-Daniel/cts-infrastructure.git
    ```
2. Change directory: Navigate to the directory where your Terraform configuration files are located using the command line. 

    ```sh
    cd cts-infrastructure
    ```

3. Initialize Terraform: Run terraform init to initialize Terraform and download the required providers and modules.

    ```sh
    terraform init
    ```

    This command sets up the backend and prepares Terraform for deployment.

4. Plan Deployment: Run terraform plan to generate an execution plan. 

    This command analyzes the configuration and displays a summary of the changes that Terraform will apply to your infrastructure.

    ```sh
    terraform plan
    ```

    Review the plan to ensure it aligns with your expectations.

5. Deploy Infrastructure: Execute terraform apply to apply the changes and deploy the infrastructure described in your configuration files. 
    
    Terraform will prompt for confirmation before proceeding. Respond with 'yes' to proceed with the deployment.

    ```sh
    terraform apply
    ```

    The command will provision resources in your Google Cloud project according to your Terraform configuration.
---
6. Destroy Infrastructure (Optional): If you want to tear down the infrastructure provisioned by Terraform, you can use the terraform destroy command. 

    Running this command will remove all the resources defined in your Terraform configuration files and associated with your project. 

    ```sh
    terraform destroy
    ```

    Terraform will prompt for confirmation before initiating the destruction. Respond with 'yes' to proceed with the infrastructure teardown.

## Terraform Infrastructure Pipeline

This is a GitHub Actions pipeline that automates the deployment of infrastructure using Terraform. 

The pipeline consists of two jobs: <b>lint</b> and <b>deploy</b>. 

The lint job checks the formatting of Terraform files, while the deploy job deploys the infrastructure if certain conditions are met.

### Workflow Triggers
The pipeline is triggered by both push and pull_request events on any branch.

### Job: lint

This job runs on an ubuntu-latest runner and performs the following steps:

1. Checkout code: Checks out the repository code using the ```actions/checkout@v2``` action.

2. Set up Terraform: Sets up the Terraform CLI using the ```hashicorp/setup-terraform@v1``` action.

3. Terraform Format Check: Checks the formatting of Terraform files using the ```terraform fmt -check=true``` command.

### Job: deploy

This job runs on the ubuntu-latest environment and is triggered only when the lint job is successful and the branch is main, and it performs the following steps:

1. Checkout code: Checks out the repository code using the ```actions/checkout@v2``` action.

2. Install Google Cloud SDK: Installs the Google Cloud SDK using the ```curl``` command and updates its components.

3. Configure Google Cloud SDK: Sets up the Google Cloud SDK using the ```google-github-actions/setup-gcloud@v0.4.0``` action. 

    It configures the service account key, project ID, default region, and default zone.

4. Set up Terraform: Sets up the Terraform CLI using the hashicorp/```setup-terraform@v1``` action.

5. Configure Google Cloud authentication: Configures the Google Cloud authentication by activating the service account and setting the environment variable GOOGLE_APPLICATION_CREDENTIALS.

6. Set Google Cloud project: Sets the Google Cloud project using the ```gcloud config set project``` command.

7. Run Terraform Init: Initializes the Terraform working directory using the ```terraform init``` command.

8. Run Terraform Plan: Generates an execution plan for Terraform using the ```terraform plan``` command.

9. Run Terraform Apply: Applies the Terraform changes using the ```terraform apply -auto-approve``` command.

<b>Note:</b> Make sure to set the appropriate secrets and variables in your GitHub repository settings to successfully run this pipeline, they are also mentioned in a table in the next section named <b>Terraform Infrastructure Pipeline Configuration</b> of this documentation.

## Terraform Infrastructure Pipeline Configuration

### Variables

To set up the Terraform Infrastructure Pipeline, you need to define the following variables:

| Variable            |  Description                                              |
|:--------------------|:----------------------------------------------------------|
| GCP_PROJECT_ID      | Google Cloud Platform region                              |
| GCP_REGION          | Google Kubernetes Engine (GKE) cluster name               |
| GCP_ZONE	          | Google Cloud Platform zone                                |

Make sure to provide the necessary values for these variables when configuring the Terraform Infrastructure Pipeline. 

### Secrets

The following secrets should be added to the GitHub repository:

| Secret          |  Description                                                       |
|:----------------|:-------------------------------------------------------------------|
| GCP_SA_KEY      | Service account key for Google Cloud Platform authentication (JSON)|


<!-- Tell the audience that this is a one time thing.. -->
<b>The Service Account that is used for authentication:</b> It's using particular rules for that action, here are the rules with explanation what they do:

1. This command adds the role roles/compute.admin to the service account one-by-one@cts-project-388707.iam.gserviceaccount.com in the project cts-project-388707. The compute.admin role grants full administrative access to Compute Engine resources within the project.

    ```sh
    gcloud projects add-iam-policy-binding cts-project-388707 --member serviceAccount:one-by-one@cts-project-388707.iam.gserviceaccount.com --role roles/compute.admin 
    ```


2. This command adds the role roles/iam.serviceAccountUser to the service account one-by-one@cts-project-388707.iam.gserviceaccount.com in the project cts-project-388707. The iam.serviceAccountUser role allows the service account to impersonate other service accounts, which is useful for certain types of access delegation.

    ```sh
    gcloud projects add-iam-policy-binding cts-project-388707 --member serviceAccount:one-by-one@cts-project-388707.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
    ```


3. This command adds the role roles/resourcemanager.projectIamAdmin to the service account one-by-one@cts-project-388707.iam.gserviceaccount.com in the project cts-project-388707. The resourcemanager.projectIamAdmin role grants full administrative access to manage IAM policies and permissions for the project.

    ```sh
    gcloud projects add-iam-policy-binding cts-project-388707 --member serviceAccount:one-by-one@cts-project-388707.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
    ```

4. This command adds the role roles/container.clusterAdmin to the service account one-by-one@cts-project-388707.iam.gserviceaccount.com in the project cts-project-388707. The container.clusterAdmin role grants full administrative access to manage Kubernetes clusters within the project.

    ```sh
    gcloud projects add-iam-policy-binding cts-project-388707 --member serviceAccount:one-by-one@cts-project-388707.iam.gserviceaccount.com --role roles/container.clusterAdmin
    ```


5. This command adds the role roles/compute.viewer to the service account one-by-one@cts-project-388707.iam.gserviceaccount.com in the project cts-project-388707. The compute.viewer role grants read-only access to view Compute Engine resources within the project.

    ```sh
    gcloud projects add-iam-policy-binding cts-project-388707 --member serviceAccount:one-by-one@cts-project-388707.iam.gserviceaccount.com --role roles/compute.viewer
    ```


6. This command adds the role roles/compute.securityAdmin to the service account one-by-one@cts-project-388707.iam.gserviceaccount.com in the project cts-project-388707. The compute.securityAdmin role grants administrative access to manage security-related aspects of Compute Engine resources within the project.

    ```sh
    gcloud projects add-iam-policy-binding cts-project-388707 --member serviceAccount:one-by-one@cts-project-388707.iam.gserviceaccount.com --role roles/compute.securityAdmin
    ```
7. This command adds the role roles/container.developer to the service account one-by-one@cts-project-388707.iam.gserviceaccount.com in the project cts-project-388707. The container.developer role grants access to develop and deploy applications on Kubernetes clusters within the project.

    ```sh
    gcloud projects add-iam-policy-binding cts-project-388707 --member serviceAccount:one-by-one@cts-project-388707.iam.gserviceaccount.com --role roles/container.developer
    ```

8. This command adds the role roles/iam.serviceAccountAdmin to the service account one-by-one@cts-project-388707.iam.gserviceaccount.com in the project cts-project-388707. The iam.serviceAccountAdmin role grants administrative access to manage service accounts and their keys within the project.

    ```sh
    gcloud projects add-iam-policy-binding cts-project-388707 --member serviceAccount:one-by-one@cts-project-388707.iam.gserviceaccount.com --role roles/iam.serviceAccountAdmin
    ```

9. To grant the `roles/storage.objectAdmin` role to a service account on a Google Cloud Storage bucket, you can use the following command:

    ```sh
    gsutil iam ch serviceAccount:<service-account-email>:roles/storage.objectAdmin gs://<your-bucket-name>
    ```

CURRENTLY HARDCODED, NEEDS UPDATE AND TESTING ONCE AGAIN!
<!-- 
<b> Make sure to change ```<project-id>``` and ```<service-account-email>``` with your own Google Cloud values. </b> -->

<!-- You would also need to run the following command: -->

<!-- ```sh
gsutil iam ch serviceAccount:<service-account-email>:roles/storage.objectViewer gs://<google-cloud-bucket-name>
```

And also run:

```sh
gsutil iam ch serviceAccount:<service-account-email>:roles/storage.objectCreator gs://<google-cloud-bucket-name>
``` -->





Maybe I just need this command after to allow: TESTING IS REQUIRED

<!-- ```sh
gsutil iam ch serviceAccount:<service-account-email>:roles/storage.objectAdmin gs://<your-bucket-name>
``` -->

## Contact
For any questions or inquiries, please contact: [Daniel Ilievski](https://www.linkedin.com/in/danielilievski/)