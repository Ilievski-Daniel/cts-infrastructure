# CTS Infrastructure

The CTS Infrastructure uses multiple modules in order to obtain it's functionality:

- GKE Cluster
- GKE Authentication
- GCP Network

There are 2 required providers that are being used:

- Google
- Kubernetes

Backend configuration:

- We use Google Cloud Storage (bucket) as a Terraform backend to securely store and manage our infrastructure state, providing durability, scalability, accessibility, collaboration, and automation.

- This CTS backend infrastructure is designed with the assumption that high availability of the GKE cluster is not required. Therefore, for the purpose of simplicity and cost-effectiveness, we will deploy the Kubernetes cluster in a single region instead of multiple regions.

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

2. Configure Google Cloud SDK: Sets up the Google Cloud SDK using the ```google-github-actions/setup-gcloud@v1``` action. 

    It configures the service account key, project ID, default region, and default zone.

3. Configure Google Cloud authentication: Configures the Google Cloud authentication by activating the service account and setting the environment variable GOOGLE_APPLICATION_CREDENTIALS.

4. Set up Terraform: Sets up the Terraform CLI using the hashicorp/```setup-terraform@v1``` action.

5. Run Terraform Init: Initializes the Terraform working directory using the ```terraform init``` command.

6. Run Terraform Plan: Generates an execution plan for Terraform using the ```terraform plan``` command.

7. Run Terraform Apply: Applies the Terraform changes using the ```terraform apply -auto-approve``` command.

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


<b>The Service Account that is used for authentication:</b> It's using particular rules for that action, here are the rules with explanation what they do:

<b>Required:</b> Before you run the commands change the ```<service-account-email>```, ```<project-id>``` and ```<bucket-name>``` respectively with your Google Cloud information.

1. Command that will apply all the required roles to the service account:

    Make sure that you are located where the ```setup-roles.sh``` script is located, and run it as the following:

    ```sh
    ./setup-roles.sh <project-id> <service-account-email> <bucket-name>
    ```

- This script/command will bind the following roles to the Service Account:

    - The compute.admin role grants full administrative access to Compute Engine resources within the project.
    
    - The iam.serviceAccountUser role allows the service account to impersonate other service accounts, which is useful for certain types of access delegation.

    - The resourcemanager.projectIamAdmin role grants full administrative access to manage IAM policies and permissions for the project.
    
    - The container.clusterAdmin role grants full administrative access to manage Kubernetes clusters within the project.
    
    - The compute.securityAdmin role grants administrative access to manage security-related aspects of Compute Engine resources within the project.

    - The iam.serviceAccountAdmin role grants administrative access to manage service accounts and their keys within the project.

    - The roles/storage.objectAdmin role provides administrative access to manage objects within a specific Cloud Storage bucket.

2. After running the script/commands, your result should look like this:

```sh
Script executed successfully!
ROLE
roles/compute.admin
roles/compute.securityAdmin
roles/container.clusterAdmin
roles/iam.serviceAccountAdmin
roles/iam.serviceAccountUser
roles/resourcemanager.projectIamAdmin
```

<b>Note:</b> These actions about adding the roles to the Service Account is a one time action, that is required so that the Infrastructure Pipeline would be able to deploy and manage the infrastructure resources.

## Contact
For any questions or inquiries, please contact: [Daniel Ilievski](https://www.linkedin.com/in/danielilievski/)