# Terraform Beginner Bootcamp 2023 - Week0

   * [Semantic Versioning](#semantic-versioning)
   * [Install Terraform](#install-terraform)
      + [Terraform CLI Changes](#terraform-cli-changes)
      + [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
      + [Linux Distribution](#linux-distribution)
      + [Gitpod Consideration](#gitpod-consideration)
      + [Working with ENV Vars](#working-with-env-vars)
      + [Set/Unset ENV Vars](#setunset-env-vars)
      + [Print Vars](#print-vars)
      + [Persistent ENV Variables](#persistent-env-variables)
      + [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
      + [Terraform Registry](#terraform-registry)
      + [Terraform Console](#terraform-console)
      + [Terraform Init](#terraform-init)
      + [Terraform Plan](#terraform-plan)
      + [Terraform Apply](#terraform-apply)
      + [Terraform State](#terraform-state)
      + [Terraform Destroy](#terraform-destroy)
      + [Terraform Cloud Integration](#terraform-cloud-integration)


## Semantic Versioning
This project will use semantic versioning

The format:
**MAJOR.MINOR.PATCH**  eg `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes1_semantic_versioning

## Install Terraform
[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Terraform CLI Changes
Terraform CLI install has changed so we needed to fix the Gitpod YML([.gitpod.yml](.gitpod.yml))

### Refactoring into Bash Scripts

Fixed TF CLI install steps and condensed into new bash script for gitpod YML to keep Gitpod working and install TF CLI easier
Bash Script: [./bin/install_terraform_cli](./bin/install_terraform_cli)

### Linux Distribution
This project is built using Ubuntu 22.
Changed permissions for the script to be user executable so taht Gitpod launch would execute the bash script
```
chmod u+x ./bin/install_terraform_cli
```
### Gitpod Consideration
If the workspace is not new it will not run the Init including the script, it only runs when a new workspace is created


### Working with ENV Vars
List all env variables with: 
```
env
```
Can filter specific env vars with grep eg 'env | grep variable'

### Set/Unset ENV Vars
```
export VARIABLE_NAME="variable_value"

unset VARIABLE_NAME
```

Temporarily set an ENV Var without export command, in terminal or bash script

### Print Vars
```
echo $VARIABLE_NAME

```

### Persistent ENV Variables

ENV vars only persist for one terminal. To use ENV Vars in another terminal, add to bash profile file like .bashrc


### AWS CLI Installation

AWS CLI is installed via bash script ['./bin/install_aws_cli'](./bin/aws_install_cli) for this project

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[Set AWS CLI ENV Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)


Check AWS Credentials:
```
aws sts get-caller-identity
```

If successful you will see an output similar to this:
```json
{
    "UserId": "A56HAGHS8773",
    "Account": "65653939830",
    "Arn": "arn:aws:iam::65653939830:user/tf-beginner-bootcamp"
}
```
# Terraform Basics

### Terraform Registry
Terraform sources providers and modules located at [registry.terraform.io](https://registry.terraform.io)

**Providers** interface with APIs to create and modify resources.
**Modules** are a way to refactor and make Terraform code modular and portable

### Terraform Console
Use **terraform** to get a list of commands usable in Terraform Console

### Terraform Init
Use **terraform init** once you've added a provider to the Terraform file (usually **main.tf**)

### Terraform Plan
**terraform plan** This generates a change set to be executed by Terraform, it outputs a list of changes to be made, resources to be created, modified or destroyed, and this can be saved as a file to be referenced later

### Terraform Apply
**terraform apply** is used to execute the change set based on the plan, it will create a tfstate file based on the results of the run. By default you must approve changes before it will run, you can use the *--auto-approve* switch with **terraform apply** to automatically approve it.

### Terraform State
A Terraform state file is created based on the execution of the plan. It should not be committed to a repo as it can contain sensitive data. This **tfstate** file is an accounting of the infrastructure and without it Terraform is not aware of what has been created

### Terraform Destroy
**terraform destroy** will destroy any resources created and managed by the tfstate file.

### Terraform Cloud Integration
Gitpod has an issue with using the TF Cloud integration for Terraform Init, it prompts for an API token and the process to get one is broken using the Gitpod terminal. Must go to TF Cloud workspace and generate the token, then create a file at [Gitpod Terraform](/home/gitpod/.terraform.d/) called **credentials.tfrc.json** 

This file will need to look like this and include the token you generate from TF Cloud website:

{
  "credentials": {
    "app.terraform.io": {
      "token": "12535367893huhuchubcudsbyugbd9y7v7d3g73d93bnd3h"
    }
  }
}

Additionally, in the Variables section of your workspace you need to add ENV Variables in TF cloud so that TF cloud can run commands with your providers that equire credentials like AWS. Create the same AWS env variables in TF cloud, marking access keys as sensitive. Then we can run the terraform commands from Gitpod and not have credential failure.

