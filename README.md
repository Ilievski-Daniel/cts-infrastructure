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

This job runs on an ubuntu-latest runner and depends on the successful completion of the lint job. It performs the following steps:

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

<b>Note:</b> Make sure to set the appropriate secrets and variables in your GitHub repository settings to successfully run this pipeline, they are also mentioned in a table in the next section of this documentation.
