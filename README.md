# Cloud Assets
This repository will focus on providing visibility of Cloud Resources and IAM, Org, Access policies at the GCP organization level. The imperative scripts will provide examples of commands to use during an incident or an analysis view in Bigquery. The declaritive Terraform templates will create real time pub/sub feeds at the GCP organization level for CONTENT_TYPE_UNSPECIFIED, RESOURCE, IAM_POLICY, ORG_POLICY, and ACCESS_POLICY events. Enjoy being able to say I know whats going on in my GCP organization!

## Software Requirements
## Gcloud SDK
Download the latest gcloud SDK
https://cloud.google.com/sdk/docs/

### Terraform software
- [Terraform](https://www.terraform.io/downloads.html) 0.12.x
- [terraform-provider-google](https://github.com/terraform-providers terraform-provider-google) plugin v3.4.0

## Imperative IAM Permissions

### Cloud Asset permission
- Individual permissions https://cloud.google.com/asset-inventory/docs/access-control#required_permissions

- Predefined roles https://cloud.google.com/asset-inventory/docs/access-control#roles

### BigQuery permission 
- Bigquery write permission for export or storage is delegated to Cloud Asset service account: service-<your project number>@gcp-sa-cloudasset.iam.gserviceaccount.com"

## Imperative scripts 

### Organization level search for assets
$ search_assets.sh --dns-domain <Your DNS Domain>

### Organization level search for iam.serviceAccounts.actAs permission
$ search_permission.sh --dns-domain <Your DNS Domain>

### Export assets (resources,iam policy, org policy, access policy) to Big Query for analysis

#### Create Bigquery dataset names assets in CLI or console

$ bq --location=US mk -d --description "$(gcloud config list --format 'value(core.account)') created assets dataset" $(gcloud config list --format 'value(core.project)'):assets

#### Load assets into Big Query table 
$ load_assets_bq.sh --dns-domain <Your DNS Domain>

### Entitlement report for users and service accounts
$ entitlement_report.sh	--dns-domain <Your DNS Domain>

### Create real time asset feeds
$ create_asset_feeds.sh --dns-domain <Your DNS Domain>

### Delete real time asset feeds
$ delete_asset_feeds.sh --dns-domain <Your DNS Domain>

## Terraform deployment

-  Create a Google Storage bucket to store Terraform state 
-  `gsutil mb gs://<your state bucket>`
-  Copy terraform.tfvars.template to terraform.tfvars 
-  `cp terraform.tfvars.template  terraform.tfvars`
-  Update required variables in terraform.tfvars for Splunk Software, GCS Bucket, and DNS configuration 
- `terraform init` to get the plugins
-  Enter Google Storage bucket that will store the Terraform state
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

#### Variables
Please refer the `variables.tf` file for the required and optional variables.

## File structure
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /versions.tf: Terraform version and forcing to Terraform state to Google Storage
- /readme.MD: this file


## Cloud Assets documents 
SQL Examples https://cloud.google.com/asset-inventory/docs/exporting-to-bigquery#querying_an_asset_snapshot


