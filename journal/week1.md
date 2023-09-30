# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Root module structure:

- Project Root
  - variables.tf - stores structure of input variables
  - main.tf
  - providers.tf - Required providers and configuration
  - outputs.tf - stores outputs
  - terraform.tfvars - data of variables to load into TF project
  - README.md
 
  [Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
## Terraform and Inpout Variables

### Terraform Cloud Variables

Set Terraform and ENV Variables in TF Cloud under the Workspace. Variables can be sensitive or not. ENV Variables are intended to pass in credentials generally and TF variables are generally used in the TF code itself.

## Loading Terraform Input Variables

### var flag
Use `-var` flag to set or override an input variable on command line, eg `terraform -var user_uuid="user_id"`

### var-file flag

### terraform.tfvars
This is the default file to load terraform variables in bulk

### auto.tfvars

- TODO: Document this for TF Cloud

### Order of Terraform Variables

- TODO: Document Terraform variable precedence

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

## Dealing with Config Drift

## Losing State File
If you lose the tfstate file, it may be required to tear down the resources manually. Not all resources support manual import.

### Fix Missing Resources with TF Import
[Terraform Import Docs](https://developer.hashicorp.com/terraform/cli/import)


### Fix Manual Configuration
If someone creates, modifies or deletes via ClickOps, TF will attempt to fix the config drift by resetting the state to what is in the tfstate file.
We can use `terraform state rm <object>` to remove something that was deleted manually, or terraform import `terraform import <code resource> <created object per docs)`

