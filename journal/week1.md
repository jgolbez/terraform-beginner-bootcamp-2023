# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locall delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete tag

```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```


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

### Fix Using TF Refresh
```sh
terraform apply --auto-approve -refresh-only
```


## Terraform Modules
[Terraform Module Docs](https://developer.hashicorp.com/terraform/language/modules)

### Terraform Module Structure
Recommended to place module in `modules` directory
Include `main.tf` and `variables.tf` and `outputs.tf` at least

### Passing Input Variables

We can pass input variables to module, module must declare TF variables in its own variables.tf file
```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.s3_website_bucket_name
}
```

### Module Sources
[Terraform Module Docs](https://developer.hashicorp.com/terraform/language/modules/sources)

Using source we can import module from:
- local path
- Github
- TF Registry

```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

## Consideration Using ChatGPT
ChatGPT and LLMs may be out of date and should not be trusted alone, verify the suggested code is not deprecated or replaced

## Working with Files in Terraform


### File Exists Function
Built-in TF function to check for existence of a file:
```
variable "error_html_filepath" {
    description = "File path to error.html"
    type = string

    validation {
        condition = fileexists(var.error_html_filepath)
        error_message = "The provided path for error.html does not exist"
    }
}
```
### FileMD5 Function
[FileMD5 checks hash of file data for changes to state](https://developer.hashicorp.com/terraform/language/functions/filemd5)


### Terraform Path References for Files
[Path References for Variables in TF](https://developer.hashicorp.com/terraform/language/expressions/references)

In TF there are special variables called `path` taht allow reference to local file structures
- path.module = get the path for the current module
- path.root = get path for root of project/module

```tf
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public.index.html"
  etag = filemd5(var.index_html_filepath)  
}
```

## Terraform Locals Resource
[Locals](https://developer.hashicorp.com/terraform/language/values/locals)
Assigns a local friendly value to some defined expression that can be reused in resource blocks as reference
```tf
locals {
    s3_origin_id = "MyS3Origin"
}
```


## Terraform Data Sources
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)
A data source is accessed via a special kind of resource known as a data resource, declared using a data block:

```tf
data "aws_ami" "example" {
  most_recent = true

  owners = ["self"]
  tags = {
    Name   = "app-server"
    Tested = "true"
  }
}
```

This allows us to grab data and reference it in Terraform as a resource, and then use that reference in other code blocks

## Working with JSON in TF
[JSON Encoding with HCL in TF](https://developer.hashicorp.com/terraform/language/functions/jsonencode)
Use jsonencode to create JSON policy in HCL

Example:
```tf
policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
            "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
            "Effect" = "Allow",
            "Principal" = {
                "Service" = "cloudfront.amazonaws.com"
            },
            "Action" = "s3:GetObject",
            "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
            "Condition" = {
            "StringEquals" = {
                "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
                }
            }
        },         
})
}
```

## Terraform Resource Lifecycle Management
[LifeCycle Management Meta Arguments](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)


## Adding TF Resource for Out-of-Band Triggers (Like for Lifecycle)
In this case we created a resource to control when we increment website version so we can control when new files are uploaded to CloudFront rather than every time an edit is made.

The below example references a resource we created and only tracks an arbitrary variable for flagging when a version changhe happens, which will trigger a new file upload next time TF plan happens:

```tf
resource "terraform_data" "content_version" {
  input = var.content_version
}
```
This lifecycle argument is added to the aws_s3_object resource so we can ignore changes to etag (md5 hash) but can trigger an upoad when we increment version

```tf
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }  
```
## Provisioners
Provisoners allow you to execute operational comands as part of a resource for actions that are not based on infrastructure state, eg AWS CLI
They are not recommended as config management is not the goal of Terraform.


### Local-Exec
[Local-Exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)
Local-Exec runs the operational commands on the machine executing the terraform apply

Example:

```tf
  provisioner "local-exec" {
    command = <<-EOT
      aws cloudfront create-invalidation \
        --distribution-id ${aws_cloudfront_distribution.s3_distribution.id} \
        --paths "/*"
    EOT   
  }
```

### Remote-Exec
[Remote-Exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)
Remote-Exec will allow targeting a different machine for the execution of commands. Provide credentials for login to execute the commands.

Example:
```tf
resource "aws_instance" "web" {
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
