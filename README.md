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

- Clone Repository: Clone the repository containing the Terraform configuration files to your local machine.

- Initialize Terraform: Navigate to the directory where your Terraform configuration files are located using the command line. 

    Run terraform init to initialize Terraform and download the required providers and modules.

    ```sh
    terraform init
    ```

    This command sets up the backend and prepares Terraform for deployment.

- Plan Deployment: Run terraform plan to generate an execution plan. 

    This command analyzes the configuration and displays a summary of the changes that Terraform will apply to your infrastructure.

    ```sh
    terraform plan
    ```

    Review the plan to ensure it aligns with your expectations.

- Deploy Infrastructure: Execute terraform apply to apply the changes and deploy the infrastructure described in your configuration files. 
    
    Terraform will prompt for confirmation before proceeding. Respond with 'yes' to proceed with the deployment.

    ```sh
    terraform apply
    ```

    The command will provision resources in your Google Cloud project according to your Terraform configuration.
---
- Destroy Infrastructure (Optional): If you want to tear down the infrastructure provisioned by Terraform, you can use the terraform destroy command. 

    Running this command will remove all the resources defined in your Terraform configuration files and associated with your project. 

    ```sh
    terraform destroy
    ```

    Terraform will prompt for confirmation before initiating the destruction. Respond with 'yes' to proceed with the infrastructure teardown.