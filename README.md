# Project Deployment Guide

## Prerequisites

To deploy this project, ensure that you have the following installed on your local machine:
- AWS CLI
- Terraform

## Setting Up AWS Account

Follow these steps to set up your AWS account with the necessary credentials:

1. Open a terminal or command prompt on your console.
2. Run the command `aws configure`.
3. Enter your access key ID.
4. Enter your secret access key.
5. Enter the default region (e.g., `eu-central-1`).
6. Enter the default output format (e.g., `json`).

## Deploying the Infrastructure

After configuring AWS, proceed with deploying the infrastructure by following these steps:

1. Open the project file in your terminal.
2. Initialize Terraform:
   ```sh
   terraform init
   ```
3. Generate a plan for the deployment:
   ```sh
   terraform plan
   ```
4. Apply the plan to deploy the infrastructure:
   ```sh
   terraform apply
   ```

## Accessing the Webpage

Once the infrastructure has been deployed, you can find the URL to the webpage in the terminal output.
